import React, { FC, memo, useEffect, useState } from 'react';
import { useRecoilState, useRecoilValue, useSetRecoilState } from 'recoil';
import { Message, Modal, Tooltip } from '@arco-design/web-react';
import { IconExport, IconLiveBroadcast, IconMessage, IconPoweroff } from '@arco-design/web-react/icon';
import classNames from 'classnames';
import { BytedIM, im_proto } from '@volcengine/im-web-sdk';
import { useLocation, useNavigate } from '@modern-js/runtime/router';

import { Avatar, Badge } from '..';
import AppNavBarBox from './Styles';
import { ACCOUNT_CHECK_ENABLE, ACCOUNTS_INFO, ENABLE_LIVE_DEMO, USER_ID_KEY } from '../../constant';
import { Storage } from '../../utils/storage';
import { BytedIMInstance, Conversations, UnReadTotal, Messages, Participants, UserId } from '../../store';
import { useLive } from '../../hooks/useLive';
import { useRequest, useTimeout } from 'ahooks';
import { deleteAccount } from '../../apis/app';

interface AppNavBarProps {}

const PATHNAMES = {
  '/': 0,
  '/live': 1,
};

function DeleteAccountModal({ visible, setVisible }: { visible: boolean; setVisible: Function }) {
  const bytedIMInstance = useRecoilValue<BytedIM>(BytedIMInstance);
  const userId = useRecoilValue(UserId);

  const [progress, setProgress] = useState('');

  const { run, loading } = useRequest(
    async () => {
      try {
        await Promise.race([
          (async () => {
            let entries = [...bytedIMInstance.getConversationList().entries()];
            let total = entries.length + 1;
            setProgress(`${0}/${total}`);
            for (let [index, conversation] of entries) {
              console.log('deleting', conversation, conversation.type);
              if (conversation.type === im_proto.ConversationType.ONE_TO_ONE_CHAT) {
                // @ts-ignore
                await bytedIMInstance.setConversationCoreInfo({ conversation, ext: { 'a:user_delete': userId } });
                await bytedIMInstance.deleteConversation({ conversation });
              } else {
                await bytedIMInstance.leaveConversation({ conversation });
              }
              setProgress(`${index + 1}/${total}`);
            }
            await deleteAccount();
            Storage.set(USER_ID_KEY, '');

            location.reload();
          })(),
          new Promise((resolve, reject) => setTimeout(() => reject(), 60 * 1000)),
        ]);
      } catch (e) {
        Message.error('注销失败');
      }
    },
    { manual: true }
  );

  return (
    <Modal
      title={'确定注销吗？'}
      visible={visible}
      okButtonProps={{ loading: loading }}
      // okText={loading ? `进度 ${progress}` : '确定'}
      hideCancel={loading}
      closable={false}
      onOk={run}
      onCancel={() => setVisible(false)}
      maskClosable={false}
      escToExit={false}
    >
      <div>
        注销后，当前账户的所有数据将会被删除且无法找回。
        <br />
        注销后，当前账户所创建的群聊将自动转让群主后退出。
        <br />
        注销一经开始将无法撤回。
      </div>
    </Modal>
  );
}

const AppNavBar: FC<AppNavBarProps> = props => {
  const [id, setUserId] = useRecoilState(UserId);
  const bytedIMInstance = useRecoilValue<BytedIM>(BytedIMInstance);
  const unReadTotal = useRecoilValue(UnReadTotal);
  const setMessages = useSetRecoilState(Messages);
  const setParticipants = useSetRecoilState(Participants);
  const setConversations = useSetRecoilState(Conversations);
  const { clearCurrentLiveConversationStatus } = useLive();
  const navigate = useNavigate();
  const location = useLocation();
  const [deleteAccountModalShow, setDeleteAccountModalShow] = useState(false);

  const [activeIndex, setActiveIndex] = useState(PATHNAMES[location.pathname] ?? 0);

  const navbarItems: any = [
    {
      key: 'message',
      icon: <IconMessage className="im-icon" />,
      name: '消息',
      handleClick: () => {
        if (activeIndex === 0) {
          return;
        }
        clearCurrentLiveConversationStatus();
        navigate('/');
        setActiveIndex(0);
      },
    },
    ENABLE_LIVE_DEMO && {
      key: 'live',
      icon: <IconLiveBroadcast className="im-icon" />,
      name: '直播',
      handleClick: () => {
        if (activeIndex === 1) {
          return;
        }
        clearCurrentLiveConversationStatus();
        navigate('/live');
        setActiveIndex(1);
      },
    },
    ACCOUNT_CHECK_ENABLE && {
      key: 'delete',
      icon: <IconPoweroff />,
      name: '注销',
      handleClick: () => {
        setDeleteAccountModalShow(true);
      },
    },
    {
      key: 'logout',
      icon: <IconExport />,
      name: '登出',
      handleClick: () => {
        Modal.confirm({
          title: '确认登出吗？',
          onOk: () => {
            bytedIMInstance?.dispose();

            Storage.set(USER_ID_KEY, '');

            setMessages([]);
            setParticipants([]);
            setConversations([]);

            clearCurrentLiveConversationStatus();

            setUserId('');

            navigate('/login');
          },
        });
      },
    },
  ].filter(Boolean);

  const [popupVisible, setPopupVisible] = useState(true);
  useTimeout(() => {
    setPopupVisible(undefined);
  }, 2000);

  return (
    <AppNavBarBox className="app-navbar">
      <Tooltip
        content={
          <span>
            当前登录：{ACCOUNTS_INFO[id]?.name}
            <br />
            点击复制 ID
          </span>
        }
        position={'rt'}
        popupVisible={popupVisible}
        trigger={'hover'}
        onVisibleChange={visible => {
          setPopupVisible(visible);
        }}
      >
        <div
          className="app-navbar-avatar-container"
          onClick={() => {
            navigator.clipboard
              .writeText(ACCOUNTS_INFO[id]?.id ?? '')
              .then(() => Message.success('复制成功'))
              .catch(() => Message.error('复制失败，请手动复制'));
          }}
        >
          <Avatar size={36} url={ACCOUNTS_INFO[id]?.url} className="avatar" />
        </div>
      </Tooltip>

      <div className="navbar-items">
        {navbarItems.map((item, index) => {
          const itemCls = classNames({
            'navbar-item': true,
            'is-active': activeIndex === index,
          });

          const count = unReadTotal && index === 0 ? unReadTotal : 0;

          return (
            <Tooltip key={item.key} content={item.name} position="rt" trigger="hover">
              <div className={itemCls} onClick={() => item.handleClick?.()}>
                <Badge count={count}>{item.icon}</Badge>
              </div>
            </Tooltip>
          );
        })}
      </div>

      <div className="app-navbar-bottom"></div>
      <DeleteAccountModal visible={deleteAccountModalShow} setVisible={setDeleteAccountModalShow} />
    </AppNavBarBox>
  );
};

export default memo(AppNavBar);

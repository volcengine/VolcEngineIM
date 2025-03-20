import React, { FC, memo, useEffect, useState } from 'react';
import { useRecoilState, useRecoilValue, useSetRecoilState } from 'recoil';
import { Form, Input, Message, Modal, Popover, Radio, Space, Spin, Tooltip, Typography } from '@arco-design/web-react';
import {
  IconEdit,
  IconExport,
  IconLiveBroadcast,
  IconMessage,
  IconPoweroff,
  IconUserGroup,
} from '@arco-design/web-react/icon';
import classNames from 'classnames';
import { BytedIM, im_proto } from '@volcengine/im-web-sdk';
import { useLocation, useNavigate } from '@modern-js/runtime/router';

import { Avatar, Badge } from '..';
import AppNavBarBox from './Styles';
import {
  ACCOUNT_CHECK_ENABLE,
  ENABLE_LIVE_DEMO,
  ENABLE_OVERSEA_SWITCH,
  IM_OVERSEA_KEY,
  IS_OVERSEA,
  USER_ID_KEY,
  STR_USER_ID_KEY,
} from '../../constant';
import { Storage } from '../../utils/storage';
import { BytedIMInstance, Conversations, Messages, Participants, UnReadTotal, UserId } from '../../store';
import { useLive } from '../../hooks/useLive';
import { useRequest, useTimeout } from 'ahooks';
import { deleteAccount } from '../../apis/app';
import { useAccountsInfo, useUnreadFriendApplyCount } from '../../hooks';
import DefaultAvatar from '../../assets/images/default_avatar.png';
import ProfilePopover from '../ProfilePopover';

interface AppNavBarProps {}
const avatars = Array(6)
  .fill(0)
  .map((_, i) => `https://lf3-static.bytednsdoc.com/obj/eden-cn/nuhbopldnuhf/im-demo-avatar/avatar${i + 1}.png`);
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
            // Storage.set(STR_USER_ID_KEY, '');

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
interface EditProfileModalModelProps {
  onClose?: () => void;
  onSubmit?: (value: { nickname?: string; portrait?: string }) => Promise<boolean>;
  userId?: string;
  initNickname?: string;
  initPortrait?: string;
  visible: boolean;
}

const EditProfileModal: FC<EditProfileModalModelProps> = props => {
  const handleCreateClick = async () => {
    try {
      await form.validate();
    } catch (e) {
      Message.error(e);
    }
    if (
      await props.onSubmit({
        nickname: form.getFieldValue('nickname') || '',
        portrait: form.getFieldValue('portrait') || '',
      })
    )
      props.onClose();
  };

  const handleCloseClick = () => {
    props.onClose();
  };

  const [form] = Form.useForm();
  useEffect(() => {
    if (props.visible) {
      form.setFieldsValue({
        nickname: props.initNickname ?? '',
        portrait: props.initPortrait ?? '',
      });
    }
  }, [props.visible]);
  return (
    <Modal title={'编辑用户资料'} onOk={handleCreateClick} onCancel={handleCloseClick} visible={props.visible}>
      <Form
        form={form}
        labelCol={{
          style: { flexBasis: 90 },
        }}
        wrapperCol={{
          style: { flexBasis: 'calc(100% - 90px)' },
        }}
        initialValues={{
          nickname: props.initNickname ?? '',
          portrait: props.initPortrait ?? '',
        }}
      >
        <Form.Item label="昵称" field="nickname">
          <Input placeholder={'请输入用户昵称'} maxLength={10} showWordLimit autoComplete={'off'} />
        </Form.Item>
        <Form.Item label="头像" field="portrait">
          <Radio.Group>
            {avatars.map(url => (
              <Radio value={url} key={url}>
                <img key={url} src={url} style={{ width: 32, height: 32, verticalAlign: 'middle', margin: '4px 0' }} />
              </Radio>
            ))}
          </Radio.Group>
        </Form.Item>
      </Form>
    </Modal>
  );
};
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

  const navbarItems: any = [
    {
      key: 'message',
      route: '/',
      icon: <IconMessage className="im-icon" />,
      name: '消息',
      handleClick: () => {
        navigate('/');
      },
    },
    ENABLE_LIVE_DEMO && {
      key: 'live',
      route: '/live',
      icon: <IconLiveBroadcast className="im-icon" />,
      name: '直播',
      handleClick: () => {
        navigate('/live');
      },
    },
    {
      key: 'contact',
      route: '/contact',
      icon: <IconUserGroup className="im-icon" />,
      name: '通讯录',
      handleClick: () => {
        navigate('/contact');
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
    ENABLE_OVERSEA_SWITCH && {
      key: 'oversea',
      icon: IS_OVERSEA ? '外' : '内',
      name: `切换区域，当前区域: ${IS_OVERSEA ? '海外' : '国内'}`,
      handleClick: () => {
        if (IS_OVERSEA) {
          localStorage.removeItem(IM_OVERSEA_KEY);
        } else {
          localStorage.setItem(IM_OVERSEA_KEY, '1');
        }
        window.location.reload();
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
            // Storage.set(STR_USER_ID_KEY, '');

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

  const activeIndex = navbarItems.findIndex(item => item.route === location.pathname);

  const [popupVisible, setPopupVisible] = useState(true);
  useTimeout(() => {
    setPopupVisible(undefined);
  }, 2000);

  const unreadApplyCount = useUnreadFriendApplyCount();

  const [showProfileEditModal, setShowProfileEditModal] = useState(false);
  const ACCOUNTS_INFO = useAccountsInfo();

  let selfInfo = ACCOUNTS_INFO[id];

  return (
    <AppNavBarBox className="app-navbar">
      <ProfilePopover userId={id} onEdit={() => setShowProfileEditModal(true)} position={'rt'}>
        <div
          className="app-navbar-avatar-container"
          onClick={() => {
            navigator.clipboard
              .writeText(selfInfo?.id ?? '')
              .then(() => Message.success('复制成功'))
              .catch(() => Message.error('复制失败，请手动复制'));
          }}
        >
          <Avatar size={36} url={ACCOUNTS_INFO[id]?.url} className="avatar" />
        </div>
      </ProfilePopover>
      <div className="navbar-items">
        {navbarItems.map((item, index) => {
          const itemCls = classNames({
            'navbar-item': true,
            'is-active': activeIndex === index,
          });

          let count = 0;
          if (unReadTotal && item.key === 'message') count = unReadTotal;
          else if (item.key === 'contact') {
            count = unreadApplyCount;
          }

          return (
            <Tooltip key={item.key} content={item.name} position="rt" trigger="hover">
              <div
                className={itemCls}
                onClick={() => {
                  if (activeIndex === index) {
                    return;
                  }
                  clearCurrentLiveConversationStatus();
                  item.handleClick?.();
                }}
              >
                <Badge count={count}>{item.icon}</Badge>
              </div>
            </Tooltip>
          );
        })}
      </div>

      <div className="app-navbar-bottom"></div>
      <DeleteAccountModal visible={deleteAccountModalShow} setVisible={setDeleteAccountModalShow} />
      <EditProfileModal
        visible={showProfileEditModal}
        onSubmit={async ({ nickname, portrait }) => {
          try {
            await bytedIMInstance.setUserProfile({
              nickname,
              portrait,
            });
          } catch (e) {
            if (e.type === im_proto.StatusCode.USER_NOT_REGISTER) {
              Message.error(`修改失败: 用户未注册`);
            } else {
              Message.error(`修改失败: ${e.type}`);
            }
            return false;
          }
          Message.success('修改成功');
          window.dispatchEvent(
            new CustomEvent('profileRequest', {
              detail: { userIds: [id], force: true },
            })
          );
          return true;
        }}
        onClose={() => setShowProfileEditModal(false)}
        initNickname={selfInfo?.realName}
        initPortrait={selfInfo?.url === DefaultAvatar ? '' : selfInfo?.url}
      ></EditProfileModal>
    </AppNavBarBox>
  );
};

export default memo(AppNavBar);

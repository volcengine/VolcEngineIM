import React, { memo, useState, useRef, useMemo, useCallback, useEffect } from 'react';

import Styles from './Styles';
import { Avatar, NoMessage, ProfilePopover } from '../../../../components';
import { ContactPanelHeader } from '../ContactPanelHeader';
import { getConversationAvatar } from '../../../../utils';
import { Button, Form, Input, List, Message, Modal, Popover, Typography } from '@arco-design/web-react';
import { useRequest } from 'ahooks';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance } from '../../../../store';
import {
  Friend,
  FriendApply,
  FriendApplyStatus,
  IMEvent,
  im_proto,
  ReplyFriendAttitude,
  BlackUserInfo,
} from '@volcengine/im-web-sdk';
import { sortBy } from 'lodash';
import { useAccountsInfo, useConversation } from '../../../../hooks';
import { useNavigate } from '@modern-js/runtime/router';
import { sleep } from '../../../../utils/sleep';

interface ChatPanelPropsType {
  selectedPanel: string;
}

function ContactItem({
  userId,
  operation,
  onClick,
  alias,
}: {
  userId: string;
  operation: React.ReactNode;
  onClick?: () => void;
  alias?: string;
}) {
  const ACCOUNTS_INFO = useAccountsInfo();

  return (
    <div key={userId} className={'contact-item'}>
      <div className={'contact-item-avatar'} onClick={onClick} style={{ cursor: onClick ? 'pointer' : 'unset' }}>
        <ProfilePopover userId={userId}>
          <Avatar url={ACCOUNTS_INFO[userId]?.url} size={36} />
        </ProfilePopover>
      </div>
      <div
        className={'contact-item-name'}
        onClick={onClick}
        style={{ cursor: onClick ? 'pointer' : 'unset', overflowWrap: 'anywhere' }}
      >
        {alias || ACCOUNTS_INFO[userId]?.name}
      </div>
      <div className={'contact-item-operation'}>{operation}</div>
    </div>
  );
}

function ApplyItem({ i, refresh }: { i: FriendApply; refresh: () => void }) {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const { loading, run } = useRequest(
    async (accept: boolean) => {
      if (accept) {
        try {
          const resp = await bytedIMInstance.replyFriendApply({
            userId: i.fromUserId,
            attitude: ReplyFriendAttitude.Accept,
            ext: { demo_from_web: 'replyFriendApply' },
          });
          console.log(resp);
        } catch (e) {
          switch (e.type) {
            case im_proto.StatusCode.FRIEND_MORE_THAN_LIMIT:
              Message.error('你的好友数量已到上限，请删除部分好友后重试');
              break;
            case im_proto.StatusCode.FROM_USER_FRIEND_MORE_THAN_LIMIT:
              Message.error('操作失败，对方的好友数量已到上限');
              break;
            default:
              Message.error(`通过好友申请失败: ${e.msg} ${e.logid}`);
              break;
          }
          return;
        }
        await bytedIMInstance.sendMessage({
          message: await bytedIMInstance.createTextMessage({
            content: JSON.stringify({ text: '我已通过你的好友申请' }),
            conversation: (await bytedIMInstance.createConversation({ participants: [i.fromUserId] })).payload,
          }),
        });
      } else {
        try {
          const resp = await bytedIMInstance.replyFriendApply({
            userId: i.fromUserId,
            attitude: ReplyFriendAttitude.Reject,
            ext: { demo_from_web: 'replyFriendApply' },
          });
          console.log(resp);
        } catch (e) {
          Message.error(`通过好友申请失败: ${e.msg} ${e.logid}`);
          return;
        }
      }
      await refresh();
    },
    { manual: true }
  );

  return (
    <ContactItem
      userId={i.fromUserId}
      operation={
        <>
          {i.status === FriendApplyStatus.Waiting && (
            <Button
              type="text"
              status="danger"
              loading={loading}
              onClick={() => {
                run(false);
              }}
            >
              拒绝
            </Button>
          )}
          {i.status === FriendApplyStatus.Waiting && (
            <Button
              type="text"
              status="success"
              loading={loading}
              onClick={() => {
                run(true);
              }}
            >
              通过
            </Button>
          )}
          {i.status === FriendApplyStatus.Refuse && <div className={'contact-item-operation-reject'}>已拒绝</div>}
          {i.status === FriendApplyStatus.Agree && <div className={'contact-item-operation-agree'}>已通过</div>}
        </>
      }
    ></ContactItem>
  );
}

function ApplyList() {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const {
    data = [],
    loading,
    refresh,
  } = useRequest(async () => {
    await sleep(200);
    const resp = await bytedIMInstance.getFriendReceiveApplyListOnline({
      limit: 500,
    });
    console.log(resp.list.map(i => i.fromUserId));
    if (resp.list.length) {
      await bytedIMInstance.markFriendReceiveApplyAsRead({
        readIndex: resp.list[0].index,
      });
    }

    return resp.list;
  }, {});

  useEffect(() => {
    const sub1 = bytedIMInstance.event.subscribe(IMEvent.FriendApply, () => {
      refresh();
    });
    const sub2 = bytedIMInstance.event.subscribe(IMEvent.FriendApplyRefuse, () => {
      refresh();
    });
    const sub3 = bytedIMInstance.event.subscribe(IMEvent.FriendAdd, () => {
      refresh();
    });
    const sub4 = bytedIMInstance.event.subscribe(IMEvent.FriendApplyUpdate, () => {
      refresh();
    });
    return () => {
      bytedIMInstance.event.unsubscribe(IMEvent.FriendApply, sub1);
      bytedIMInstance.event.unsubscribe(IMEvent.FriendApplyRefuse, sub2);
      bytedIMInstance.event.unsubscribe(IMEvent.FriendAdd, sub3);
      bytedIMInstance.event.unsubscribe(IMEvent.FriendApplyUpdate, sub4);
    };
  }, []);
  return (
    <List
      size="small"
      dataSource={data}
      loading={loading}
      style={{ border: 'none' }}
      render={i => {
        return <ApplyItem key={i.fromUserId} i={i} refresh={refresh} />;
      }}
    />
  );
}

function FriendAliasModal({ visible, value, loading, setVisible, onSubmit }) {
  const [form] = Form.useForm();

  function onOk() {
    form
      .validate()
      .then(res => {
        onSubmit(res.alias);
      })
      .catch();
  }

  useEffect(() => {
    form.setFieldsValue({ alias: value });
  }, [visible]);
  return (
    <Modal
      title="修改好友备注"
      visible={visible}
      onOk={onOk}
      confirmLoading={loading}
      onCancel={() => setVisible(false)}
      mountOnEnter={true}
    >
      <Form
        form={form}
        initialValues={{ alias: value }}
        labelCol={{
          style: { flexBasis: 90 },
        }}
        wrapperCol={{
          style: { flexBasis: 'calc(100% - 90px)' },
        }}
      >
        <Form.Item label="备注" field="alias">
          <Input
            placeholder="输入备注"
            maxLength={96}
            showWordLimit={true}
            normalizeTrigger={['onBlur']}
            normalize={v => (v ? v.trim() : v)}
          />
        </Form.Item>
      </Form>
    </Modal>
  );
}

function FriendItem({ i, refresh }: { i: Friend; refresh: () => void }) {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const { loading, run } = useRequest(
    async () => {
      const resp = await bytedIMInstance.deleteFriend({ userIds: [i.userId] });
      // 删除好友后同步删除会话
      const target = bytedIMInstance.getConversationList({
        filter: conv =>
          conv.type === im_proto.ConversationType.ONE_TO_ONE_CHAT && conv.toParticipantUserId === i.userId,
      })?.[0];
      if (target) {
        await bytedIMInstance.deleteConversation({ conversation: target });
      }
      Message.success('操作成功');
      await refresh();
    },
    { manual: true }
  );

  const { loading: changeLoading, run: changeRun } = useRequest(
    async v => {
      try {
        const resp = await bytedIMInstance.updateFriend({
          userId: i.userId,
          alias: v,
          ext: { ...i.ext, demo_from_web: 'updateFriend' },
        });
        Message.success('操作成功');
        setAliasEditVisible(false);
        await refresh();
      } catch (e) {
        if (e.type === im_proto.StatusCode.ALIAS_TOO_LONG) Message.error('好友备注过长');
        else if (e.type === im_proto.StatusCode.ALIAS_ILLEGAL) Message.error('文本中可能包含敏感词，请修改后重试');
        else Message.error(e.msg);
      }
    },
    { manual: true }
  );

  const { createOneOneConversation } = useConversation();
  const navigate = useNavigate();
  const [aliasEditVisible, setAliasEditVisible] = useState(false);

  return (
    <ContactItem
      userId={i.userId}
      alias={i.alias}
      operation={
        <>
          <Button
            type="text"
            onClick={() => {
              setAliasEditVisible(true);
            }}
            loading={loading}
          >
            修改好友备注
          </Button>
          <Button
            type="text"
            status="danger"
            onClick={() => {
              Modal.confirm({
                title: '确认删除好友?',
                content: '删除好友意味着你与对方解除好友关系',
                onOk: () => run(),
                okButtonProps: {
                  status: 'danger',
                },
              });
            }}
            loading={loading}
          >
            删除
          </Button>
          <FriendAliasModal
            loading={changeLoading}
            onSubmit={v => {
              changeRun(v);
            }}
            value={i.alias}
            visible={aliasEditVisible}
            setVisible={v => setAliasEditVisible(v)}
          ></FriendAliasModal>
        </>
      }
      onClick={() => {
        createOneOneConversation(i.userId);
        navigate('/');
      }}
    ></ContactItem>
  );
}

function FriendList() {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const ACCOUNTS_INFO = useAccountsInfo();

  const {
    data = [],
    loading,
    refresh,
  } = useRequest(async () => {
    await sleep(200);
    const resp = await bytedIMInstance.getFriendListOnline({
      limit: 500,
    });
    console.log(resp.list);
    return sortBy(resp.list, [o => ACCOUNTS_INFO[o.userId].name]);
  }, {});

  useEffect(() => {
    const sub1 = bytedIMInstance.event.subscribe(IMEvent.FriendAdd, () => {
      refresh();
    });
    const sub2 = bytedIMInstance.event.subscribe(IMEvent.FriendDelete, () => {
      refresh();
    });
    const sub3 = bytedIMInstance.event.subscribe(IMEvent.FriendUpdate, () => {
      refresh();
    });

    return () => {
      bytedIMInstance.event.unsubscribe(IMEvent.FriendAdd, sub1);
      bytedIMInstance.event.unsubscribe(IMEvent.FriendDelete, sub2);
      bytedIMInstance.event.unsubscribe(IMEvent.FriendUpdate, sub3);
    };
  }, []);

  return (
    <List
      size="small"
      dataSource={data}
      loading={loading}
      style={{ border: 'none' }}
      render={i => {
        return <FriendItem key={i.userId} i={i} refresh={refresh} />;
      }}
    />
  );
}

function BlacklistItem({ i, refresh }: { i: BlackUserInfo; refresh: () => void }) {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const { loading, run } = useRequest(
    async () => {
      const resp = await bytedIMInstance.removeUserFromBlack({ userIds: [i.userId] });
      Message.success('操作成功');
      await refresh();
    },
    { manual: true }
  );

  return (
    <ContactItem
      userId={i.userId}
      operation={
        <>
          <Button
            type="text"
            status="danger"
            loading={loading}
            onClick={() => {
              run();
            }}
          >
            解除拉黑
          </Button>
        </>
      }
    ></ContactItem>
  );
}

function BlackList() {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const {
    data = [],
    loading,
    refresh,
  } = useRequest(async () => {
    await sleep(200);
    const resp = await bytedIMInstance.getBlacklistOnline({
      limit: 500,
    });
    console.log(resp.list);
    return sortBy(resp.list, ['userId']);
  }, {});

  useEffect(() => {
    const sub1 = bytedIMInstance.event.subscribe(IMEvent.BlacklistAdd, () => {
      refresh();
    });
    const sub2 = bytedIMInstance.event.subscribe(IMEvent.BlacklistRemove, () => {
      refresh();
    });
    const sub3 = bytedIMInstance.event.subscribe(IMEvent.BlacklistUpdate, () => {
      refresh();
    });

    return () => {
      bytedIMInstance.event.unsubscribe(IMEvent.BlacklistAdd, sub1);
      bytedIMInstance.event.unsubscribe(IMEvent.BlacklistRemove, sub2);
      bytedIMInstance.event.unsubscribe(IMEvent.BlacklistUpdate, sub3);
    };
  }, []);

  return (
    <List
      size="small"
      dataSource={data}
      loading={loading}
      style={{ border: 'none' }}
      render={i => {
        return <BlacklistItem key={i.userId} i={i} refresh={refresh} />;
      }}
    />
  );
}

function BotList() {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const ACCOUNTS_INFO = useAccountsInfo();
  const { createBotOneOneConversation, getBotList } = useConversation();
  const navigate = useNavigate();

  const {
    data = [],
    loading,
    refresh,
  } = useRequest(async () => {
    // await sleep(200);
    const list = await getBotList();
    return list;
  }, {});

  const onCreateBotConversation = async (uid: string) => {
    createBotOneOneConversation(uid);
    navigate('/');
  };

  return (
    <List
      size="small"
      dataSource={data}
      loading={loading}
      style={{ border: 'none' }}
      render={(item, index) => (
        <List.Item
          key={item.uid || index}
          onClick={() => {
            onCreateBotConversation(item.uid);
          }}
        >
          <List.Item.Meta
            // avatar={
            //   <Popover
            //     content={
            //       <div>
            //         <div>{item.nick_name}</div>
            //         <div>
            //           ID: <Typography.Text copyable>{item.uid}</Typography.Text>
            //         </div>
            //       </div>
            //     }
            //   >
            //     <div>
            //       <Avatar url={item.portrait} size={36} />
            //     </div>
            //   </Popover>
            // }
            avatar={<Avatar url={item.portrait} size={36} />}
            title={`${item.nick_name} ID: ${item.uid}`}
          />
        </List.Item>
      )}
    />
  );
}

export const ContactPanel: React.FC<ChatPanelPropsType> = memo(({ selectedPanel }) => {
  /** 无消息 */
  const renderNoMessage = useMemo(() => {
    return <NoMessage />;
  }, []);

  return (
    <Styles className="chat-panel-container">
      {selectedPanel ? (
        <>
          <ContactPanelHeader selectedPanel={selectedPanel}></ContactPanelHeader>
          <div className={'contact-list-scroll'}>
            <div className={'contact-list'}>
              {selectedPanel === 'apply' && <ApplyList></ApplyList>}
              {selectedPanel === 'my' && <FriendList></FriendList>}
              {selectedPanel === 'black' && <BlackList></BlackList>}
              {selectedPanel === 'bot' && <BotList></BotList>}
            </div>
          </div>
        </>
      ) : (
        renderNoMessage
      )}
    </Styles>
  );
});

import { useState, useEffect, useRef } from 'react';
import { useRecoilState, useSetRecoilState } from 'recoil';
import {
  IMOption,
  im_proto,
  MultimediaPlugin,
  BytedIM,
  IMEvent,
  LivePlugin,
  ContactPlugin,
  Message,
} from '@volcengine/im-web-sdk';
import { Modal, Message as ArcoMessage } from '@arco-design/web-react';
import lang from 'lodash/lang';
import { useDebounceFn } from 'ahooks';

import {
  BytedIMInstance,
  Conversations,
  CurrentConversation,
  CurrentConversationUnreadCount,
  UnReadTotal,
  Messages,
  Participants,
  UserId,
  LiveConversations,
  IsMuted,
  LiveConversationMemberCount,
  LiveConversationOwner,
} from '../store';
import { APP_ID, USER_ID_KEY, IM_TOKEN_KEY, SDK_OPTION, ACCOUNTS_INFO } from '../constant';
import { fetchToken } from '../apis/app';
import { Storage, computedVisibleTime } from '../utils';
import { useLive } from './useLive';
import { useNavigate } from '@modern-js/runtime/router';

const { ConversationType } = im_proto;

const init = ({ userId, deviceId }) => {
  const option = SDK_OPTION;

  const params: IMOption = {
    ...option,
    deviceId: deviceId ?? userId, // 影响推送，
    userId,
    debug: true,
    timeCalibration: true,
    token: () =>
      getToken({
        appId: APP_ID,
        userId,
      }),
  };

  const plugins = [LivePlugin, MultimediaPlugin, ContactPlugin];

  return new BytedIM(params, plugins);
};

const getToken = async ({ appId, userId }) => {
  const reqbody = await fetchToken({ appId, userId });
  const token = reqbody.Token;
  Storage.set(IM_TOKEN_KEY, token);
  return token;
};

const useInit = () => {
  const [loading, setLoading] = useState(true);
  const [userId, setUserId] = useRecoilState(UserId);
  const [bytedIMInstance, setBytedIMInstance] = useRecoilState(BytedIMInstance);
  const [conversations, setConversations] = useRecoilState(Conversations);
  const setUnReadTotal = useSetRecoilState(UnReadTotal);
  const [currentConversation, setCurrentConversation] = useRecoilState(CurrentConversation);
  const setCurrentConversationUnreadCount = useSetRecoilState(CurrentConversationUnreadCount);
  const _setMessages = useSetRecoilState(Messages);
  const setMessages = (list: Message[]) => {
    const newList = computedVisibleTime(list);
    if (currentConversation.type === ConversationType.MASS_CHAT)
      newList.sort((a, b) => Number(a.createdAt) - Number(b.createdAt));
    _setMessages(newList);
  };

  const setParticipants = useSetRecoilState(Participants);
  const [liveConversations, setLiveConversations] = useRecoilState(LiveConversations);
  const setIsMuted = useSetRecoilState(IsMuted);
  const isShowExpiredToast = useRef(false);
  const { clearCurrentLiveConversationStatus } = useLive();
  const [liveMessagesMap, setLiveMessagesMap] = useState(new Map());
  const setLiveConversationOwner = useSetRecoilState(LiveConversationOwner);

  /**
   * 获取会话最新消息列表
   */
  const { run: getMessageList } = useDebounceFn(
    () => {
      if (currentConversation) {
        const list = currentConversation.getMessageList() ?? [];
        setMessages(list);
      }
    },
    {
      wait: 50,
      leading: true,
    }
  );

  /**
   * 获取群成员列表
   */
  const getParticipantList = () => {
    if (currentConversation) {
      const newList = bytedIMInstance.getParticipants({
        conversation: currentConversation,
      });
      setParticipants(newList);
    }
  };

  // 实例化im
  useEffect(() => {
    (async () => {
      if (!userId) return;
      const im: BytedIM = await init({ userId, deviceId: userId });
      setBytedIMInstance(() => im);

      im?.event?.subscribe?.(IMEvent.InitFinish, () => {
        setTimeout(() => setLoading(false), 20);
      });

      const resp = await im?.init();
      if (resp !== 3) {
        alert('IM SDK 初始化失败，请检查 SDK 配置或 Token 是否有误');
        Storage.set(USER_ID_KEY, '');
        Storage.set(IM_TOKEN_KEY, '');
        location.reload();
      }
    })();

    return () => {
      bytedIMInstance?.dispose();
    };
  }, [userId]);

  const navigate = useNavigate();

  useEffect(() => {
    const tokenExpiredHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.TokenExpired, () => {
      if (isShowExpiredToast.current) {
        return;
      }
      isShowExpiredToast.current = true;
      Modal.warning({
        title: '账号已过期，请重新登录',
        onOk: () => {
          bytedIMInstance.dispose();

          Storage.set(USER_ID_KEY, '');

          setMessages([]);
          setParticipants([]);
          setConversations([]);

          clearCurrentLiveConversationStatus();

          navigate('/login');
          setUserId('');
          isShowExpiredToast.current = false;
        },
      });
    });

    const conversationChangeHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.ConversationChange, () => {
      setConversations(bytedIMInstance.getConversationList());
    });

    return () => {
      bytedIMInstance?.event.unsubscribe(IMEvent.TokenExpired, tokenExpiredHandler);
      bytedIMInstance?.event.unsubscribe(IMEvent.ConversationChange, conversationChangeHandler);
    };
  }, [bytedIMInstance]);

  useEffect(() => {
    const conversationUpsertHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.ConversationUpsert, conversation => {
      if (conversation.id === currentConversation?.id) {
        if (conversation.type === ConversationType.MASS_CHAT) {
          currentConversation.coreInfo.mergeCore(conversation.coreInfo);
          const index = liveConversations.findIndex(item => item.id === conversation.id);
          if (index > -1) {
            liveConversations[index] = currentConversation;
            setLiveConversations([...liveConversations]);
          }
        } else {
          setCurrentConversationUnreadCount(conversation.unreadCount);
        }

        setCurrentConversation(lang.cloneDeep(currentConversation));
      }
    });

    const conversationLeaveHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.ConversationLeave, conversation => {
      if (conversation.id === currentConversation?.id && conversation.coreInfo.owner !== userId) {
        Modal.warning({
          title: conversation.type === ConversationType.MASS_CHAT ? '你已不在该直播群' : '你已不在该群组',
          okText: '确定',
          onOk() {
            clearCurrentLiveConversationStatus();
          },
        });
      }
    });

    const conversationDissolveHandler = bytedIMInstance?.event?.subscribe?.(
      IMEvent.ConversationDissolve,
      conversation => {
        if (conversation.type === ConversationType.MASS_CHAT) {
          const index = liveConversations.findIndex(item => item.id === conversation.id);
          if (index > -1) {
            liveConversations.splice(index, 1);
            setLiveConversations([...liveConversations]);
          }
        }
        if (conversation.id !== currentConversation?.id) {
          return;
        }
        Modal.warning({
          title: '你已不在该群组',
          okText: '确定',
          onOk() {
            clearCurrentLiveConversationStatus();
          },
        });
      }
    );

    const conversationBlockHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.ConversationBlock, conversation => {
      if (conversation.id === currentConversation?.id) {
        currentConversation.coreInfo.blockStatus = conversation.coreInfo.blockStatus;
        currentConversation.coreInfo.blockNormalOnly = conversation.coreInfo.blockNormalOnly;
        setCurrentConversation(lang.cloneDeep(currentConversation));
      }
    });

    const participantBlockHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.ParticipantBlock, participant => {
      const { conversationId, userId: uid } = participant;
      if (conversationId === currentConversation?.id && uid === userId) {
        setIsMuted(participant.blocked);
      }
    });

    const participantUpsertHandle = bytedIMInstance?.event?.subscribe?.(IMEvent.ParticipantUpsert, () => {
      getParticipantList();
    });

    const participantJoinHandle = bytedIMInstance?.event?.subscribe?.(IMEvent.ParticipantJoin, ({ participants }) => {
      const firstParticipant = participants?.[0];
      if (firstParticipant?.conversationId !== currentConversation?.id) {
        return;
      }
    });

    const participantLeaveHandle = bytedIMInstance?.event?.subscribe?.(
      IMEvent.ParticipantLeave,
      ({ participants, operatorType }) => {
        const firstParticipant = participants?.[0];
        if (firstParticipant?.conversationId !== currentConversation?.id) {
          return;
        }
        const participant = participants?.find(p => String(p.userId) === userId);
        if (participant && operatorType === 2) {
          Modal.warning({
            title: '你已被踢出该群组',
            okText: '确定',
            onOk() {
              clearCurrentLiveConversationStatus();
            },
          });
        }
      }
    );

    const ownerChangeHandle = bytedIMInstance?.event?.subscribe?.(
      IMEvent.ConversationOwnerChange,
      ({ oldOwnerId, newOwnerId }) => {
        ArcoMessage.info(`群主由${oldOwnerId}变成${newOwnerId}`);
        setLiveConversationOwner(String(newOwnerId));
      }
    );

    const upsertHandle = bytedIMInstance?.event?.subscribe?.(IMEvent.MessageUpsert, msg => {
      if (msg.conversationId !== currentConversation?.id) {
        return;
      }
      if (msg.conversationType === ConversationType.MASS_CHAT) {
        liveMessagesMap.set(msg.clientId, msg);
        setMessages([...liveMessagesMap.values()]);
      } else {
        getMessageList();
      }
    });

    const deleteHandle = bytedIMInstance?.event?.subscribe?.(IMEvent.MessageDelete, msg => {
      if (msg.conversationId !== currentConversation?.id) {
        return;
      }
      if (msg.conversationType === ConversationType.MASS_CHAT) {
        if (liveMessagesMap.has(msg.clientId)) {
          liveMessagesMap.delete(msg.clientId);
          setMessages([...liveMessagesMap.values()]);
        }
      }
    });

    const friendApplyHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.FriendApply, msg => {
      // Message.info(`收到来自 ${ACCOUNTS_INFO[msg.from_user_id].name} 的好友申请`);
    });
    const friendApplyRefuseHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.FriendApplyRefuse, msg => {
      // Message.info(
      //   `${ACCOUNTS_INFO[msg.from_user_id].name} 发给 ${ACCOUNTS_INFO[msg.to_user_id].name} 的好友申请被拒绝`
      // );
    });
    const friendAddHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.FriendAdd, msg => {
      // Message.info(`${ACCOUNTS_INFO[msg.from_user_id].name} 添加好友 ${ACCOUNTS_INFO[msg.to_user_id].name}`);
    });
    const friendDeleteHandler = bytedIMInstance?.event?.subscribe?.(IMEvent.FriendDelete, msg => {
      // Message.info(`${ACCOUNTS_INFO[msg.from_user_id].name} 将好友 ${ACCOUNTS_INFO[msg.to_user_id].name} 删除`);
    });

    let loadLiveHistoryListener = async event => {
      for (let msg of event.detail.messages) {
        liveMessagesMap.set(msg.clientId, msg);
      }
      setMessages([...liveMessagesMap.values()]);
    };

    window.addEventListener('loadLiveHistory', loadLiveHistoryListener);

    return () => {
      bytedIMInstance?.event.unsubscribe(IMEvent.ConversationUpsert, conversationUpsertHandler);
      bytedIMInstance?.event.unsubscribe(IMEvent.ConversationLeave, conversationLeaveHandler);
      bytedIMInstance?.event.unsubscribe(IMEvent.ConversationDissolve, conversationDissolveHandler);
      bytedIMInstance?.event.unsubscribe(IMEvent.ConversationBlock, conversationBlockHandler);
      bytedIMInstance?.event.unsubscribe(IMEvent.MessageUpsert, upsertHandle);
      bytedIMInstance?.event.unsubscribe(IMEvent.MessageDelete, deleteHandle);
      bytedIMInstance?.event.unsubscribe(IMEvent.ParticipantBlock, participantBlockHandler);
      bytedIMInstance?.event.unsubscribe(IMEvent.ParticipantUpsert, participantUpsertHandle);
      bytedIMInstance?.event.unsubscribe(IMEvent.ParticipantJoin, participantJoinHandle);
      bytedIMInstance?.event.unsubscribe(IMEvent.ParticipantLeave, participantLeaveHandle);
      bytedIMInstance?.event.unsubscribe(IMEvent.ConversationOwnerChange, ownerChangeHandle);

      bytedIMInstance?.event.unsubscribe(IMEvent.FriendApply, friendApplyHandler);
      bytedIMInstance?.event.unsubscribe(IMEvent.FriendApplyRefuse, friendApplyRefuseHandler);
      bytedIMInstance?.event.unsubscribe(IMEvent.FriendAdd, friendAddHandler);
      bytedIMInstance?.event.unsubscribe(IMEvent.FriendDelete, friendDeleteHandler);
      window.removeEventListener('loadLiveHistory', loadLiveHistoryListener);
    };
  }, [bytedIMInstance, currentConversation?.id]);

  // 获取消息未读数
  useEffect(() => {
    const unReadTotal = conversations.reduce((acc, item) => acc + (item.isMuted ? 0 : item.unreadCount), 0);

    setUnReadTotal(unReadTotal);
  }, [conversations]);

  // 初始化新会话的消息和成员
  useEffect(() => {
    if (currentConversation?.type === ConversationType.MASS_CHAT) {
      setMessages([]);
      setLiveMessagesMap(new Map());
    } else {
      getMessageList();
      getParticipantList();
    }
  }, [currentConversation?.id]);

  return {
    loading,
  };
};

export default useInit;

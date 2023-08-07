import { useCallback, useEffect } from 'react';
import { useRecoilState, useRecoilValue, useSetRecoilState } from 'recoil';
import { Message } from '@arco-design/web-react';
import { im_proto } from '@volcengine/im-web-sdk';

import { BytedIMInstance, CurrentConversation, LiveConversationMemberCount, Participants, UserId } from '../store';
import useMessage from './useMessage';
import { ACCOUNTS_INFO, ROLE } from '../constant';
import { useRequest } from 'ahooks';

const { ConversationOperationStatus } = im_proto;

export const useParticipant = () => {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);
  const [participants, setParticipants] = useRecoilState(Participants);
  const { sendSystemMessage } = useMessage();
  const setLiveConversationMemberCount = useSetRecoilState(LiveConversationMemberCount);
  const userId = useRecoilValue(UserId);

  /**
   * 根据成员id获取成员对象
   */
  const getParticipantById = useCallback(
    id => {
      return participants?.find(p => p.userId === id);
    },
    [participants]
  );

  /**
   * 移除群成员
   * @param id 群id
   * @param participants 移除成员userId数组
   * @param bizExt
   */
  const removeGroupParticipants = async (
    id: string,
    participants: string[],
    bizExt?: {
      [key: string]: string;
    }
  ) => {
    if (currentConversation?.id) {
      await bytedIMInstance.removeParticipants({
        conversation: currentConversation,
        participant: participants,
        bizExt,
      });
      await sendSystemMessage(
        currentConversation,
        `${participants.map(id => ACCOUNTS_INFO[id]?.name).join('、')} 退出群聊`
      );
    }
  };

  /**
   * 添加群成员
   * @param id 群id
   * @param participants 添加成员userId数组
   * @param bizExt
   */
  const addGroupParticipants = async (
    id: string,
    participants: string[],
    bizExt?: {
      [key: string]: string;
    }
  ) => {
    if (currentConversation?.id) {
      const { statusCode, statusMsg } = await bytedIMInstance.addParticipants({
        conversation: currentConversation,
        participant: participants.map(String),
        bizExt,
      });
      if (
        [
          ConversationOperationStatus.MORE_THAN_USER_CONVERSATION_COUNT_LIMITS,
          ConversationOperationStatus.MASS_CONV_TOUCH_LIMIT,
        ].includes(statusCode)
      ) {
        const info = JSON.parse(statusMsg);
        Message.error(`${info?.moreThanConversationCountLimitUserIds} 加群个数超过上限`);
        return false;
      }
      await sendSystemMessage(
        currentConversation,
        `${participants.map(id => ACCOUNTS_INFO[id]?.name).join('、')} 加入群聊`
      );
      return true;
    }
  };

  /**
   * 删除直播群成员
   * @param id 群id
   * @param participants 添加成员userId数组
   * @param bizExt
   */
  const removeLiveGroupParticipants = async (
    conversation,
    participants: string[],
    bizExt?: {
      [key: string]: string;
    }
  ) => {
    const { statusCode, statusMsg } =
      participants.length === 1 && participants[0] === userId
        ? await bytedIMInstance.leaveLiveGroup({
            conversation,
            bizExt,
          })
        : await bytedIMInstance.removeParticipants({
            conversation,
            participant: participants,
            bizExt,
          });
    return true;
  };

  /**
   * 添加直播群成员
   * @param id 群id
   * @param participants 添加成员userId数组
   * @param bizExt
   */
  const addLiveGroupParticipants = async (
    conversation,
    participants: string[],
    bizExt?: {
      [key: string]: string;
    }
  ) => {
    const { statusCode, statusMsg } =
      participants.length === 1 && participants[0] === userId
        ? await bytedIMInstance.joinLiveGroup({
            conversation,
            bizExt,
          })
        : await bytedIMInstance.addParticipants({
            conversation,
            participant: participants,
            bizExt,
          });
    if (statusCode === ConversationOperationStatus.TOUCH_LIMITS) {
      Message.error(`直播群人数已达上限`);
      return false;
    }
    if (statusCode === ConversationOperationStatus.MEMBER_IS_BLOCK) {
      Message.error(`已被加入黑名单，无法进入直播群`);
      return false;
    }
    if (statusCode !== 0) {
      Message.error('进入直播群失败');
      return false;
    }

    void startCountPolling();
    return true;
  };

  /**
   * 设置群主和管理员
   * @param id
   * @param userId
   * @param config
   */
  const updateGroupParticipant = async (
    id: string,
    userId: string,
    config?: {
      role?: 0 | 1 | 2; // 0: 普通成员; 1: 群主; 2: 管理员
      alias?: string;
      bizExt?: {
        [key: string]: string;
      };
    }
  ) => {
    try {
      if (currentConversation?.id) {
        await bytedIMInstance.updateParticipant({
          conversation: currentConversation,
          userId,
          ...config,
        });
      }
    } catch (e) {
      Message.error(e.message);
      throw e;
    }
  };

  /**
   * 设置群主和管理员，并发送消息通知
   * @param id
   * @param userId
   * @param config
   */
  const updateGroupParticipantWithTips = async (
    id: string,
    userId: string,
    config?: {
      role?: 0 | 1 | 2; // 0: 普通成员; 1: 群主; 2: 管理员
      alias?: string;
      bizExt?: {
        [key: string]: string;
      };
    }
  ) => {
    if (currentConversation?.id) {
      await sendSystemMessage(
        currentConversation,
        `${ACCOUNTS_INFO[userId]?.name} ${config?.role === ROLE.Manager ? '成为' : '被取消'}管理员`
      );
      await bytedIMInstance.updateParticipant({
        conversation: currentConversation,
        userId,
        ...config,
      });
    }
  };

  const getParticipantsOnline = async (limit: number, cursor) => {
    return await bytedIMInstance.getParticipantsOnline({
      conversation: currentConversation,
      limit,
      cursor,
    });
  };

  const getLiveParticipantsOnline = async (limit: number, cursor) => {
    const result = await bytedIMInstance.getLiveParticipantsOnline({
      conversation: currentConversation,
      limit,
      cursor,
    });

    return result;
  };

  const getMuteParticipantsOnline = async (limit: number, cursor) => {
    return await bytedIMInstance.getMuteParticipantsOnline({
      conversation: currentConversation,
      limit,
      cursor,
    });
  };

  const getLiveParticipantMuteWhiteListOnline = async (limit: number, cursor) => {
    return await bytedIMInstance.getLiveParticipantMuteWhiteListOnline({
      conversation: currentConversation,
      limit,
      cursor,
    });
  };

  const getBlockParticipantsOnline = async (limit: number, cursor) => {
    return await bytedIMInstance.getBlockParticipantsOnline({
      conversation: currentConversation,
      limit,
      cursor,
    });
  };

  const setParticipantMuteTime = async params => {
    if (!currentConversation?.id) {
      return {};
    }
    const { memberIds, blockTime = 0, block } = params;

    return await bytedIMInstance.setParticipantMuteTime({
      conversation: currentConversation,
      blockDuration: {
        [memberIds]: blockTime,
      },
      block,
    });
  };

  const setParticipantBlockTime = async params => {
    if (!currentConversation?.id) {
      return {};
    }
    const { memberIds, blockTime = 0, block } = params;

    return await bytedIMInstance.setParticipantBlockTime({
      conversation: currentConversation,
      blockDuration: {
        [memberIds]: blockTime,
      },
      block,
    });
  };

  const addLiveParticipantMuteWhiteList = async (pids: string[]) => {
    return await bytedIMInstance.addLiveParticipantMuteWhiteList({
      conversation: currentConversation,
      participantIds: pids,
    });
  };
  const removeLiveParticipantMuteWhiteList = async (pids: string[]) => {
    return await bytedIMInstance.removeLiveParticipantMuteWhiteList({
      conversation: currentConversation,
      participantIds: pids,
    });
  };

  const { run: startCountPolling } = useRequest(
    async () => {
      if (currentConversation?.type !== im_proto.ConversationType.MASS_CHAT) return;
      const count = (
        await bytedIMInstance.getLiveParticipantCountOnline({
          conversation: currentConversation,
        })
      )?.count;
      setLiveConversationMemberCount(count);
    },
    {
      refreshDeps: [currentConversation],
      debounceWait: 300,
      pollingInterval: 10000,
    }
  );

  return {
    getParticipantById,
    removeGroupParticipants,
    addGroupParticipants,
    updateGroupParticipant,
    addLiveGroupParticipants,
    removeLiveGroupParticipants,
    getLiveParticipantsOnline,
    getMuteParticipantsOnline,
    getBlockParticipantsOnline,
    setParticipantMuteTime,
    setParticipantBlockTime,
    getParticipantsOnline,
    updateGroupParticipantWithTips,
    getLiveParticipantMuteWhiteListOnline,
    addLiveParticipantMuteWhiteList,
    removeLiveParticipantMuteWhiteList,
  };
};

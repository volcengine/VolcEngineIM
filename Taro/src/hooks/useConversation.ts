import { useCallback } from 'react';
import { useDispatch } from 'react-redux';

import { selectConversation, selectIm, setConversation } from '../store/imReducers';
import { useAppSelector } from '../store/hooks';
import { ACCOUNTS_INFO } from '../utils/account';
import { useMessage } from './useMessage';
import { selectUser } from '../store/userReducers';

export const useConversation = () => {
  const instance = useAppSelector(selectIm);
  const oldConversation = useAppSelector(selectConversation);
  const dispatch = useDispatch();
  const bytedIMInstance = instance;
  const { sendSystemMessage } = useMessage();
  const userId = useAppSelector(selectUser).id;
  const getConversation = (id: string) => {
    try {
      if (!id) return null;
      const conv = bytedIMInstance?.getConversation?.({ conversationId: id });
      if (conv?.id) {
        return conv;
      }
    } catch (error) {
      console.log(`根据id: ${id}获取会话失败`);
      throw Error(`根据id: ${id}获取会话失败`);
    }
  };

  const setCurrentConversation = useCallback(
    ({ id }) => {
      if (oldConversation && id === oldConversation.id) {
        return;
      }
      const newCurrentConversation = instance.getConversation({
        conversationId: id
      });
      if (!newCurrentConversation) {
        return;
      }
      dispatch(setConversation(newCurrentConversation));
    },
    [oldConversation, instance, dispatch]
  );
  /**
   * 退群
   * @param id 群id
   */
  const leaveGroupConversation = async (id: string) => {
    const conv = getConversation(id);

    if (conv?.id) {
      await sendSystemMessage(conv, `${ACCOUNTS_INFO[userId]?.realName} 退出群聊`);
      await bytedIMInstance?.leaveConversation({
        conversation: conv
      });
      setCurrentConversation(null);
    }
  };

  /**
   * 解散群（群主）
   * @param id 群id
   */
  const dissolveGroupConversation = async (id: string) => {
    const conv = getConversation(id);

    if (conv?.id) {
      await sendSystemMessage(conv, '群聊被解散');
      await bytedIMInstance?.dissolveConversation({
        conversation: conv
      });
      setCurrentConversation(null);
    }
  };

  return {
    setCurrentConversation,
    leaveGroupConversation,
    dissolveGroupConversation
  };
};

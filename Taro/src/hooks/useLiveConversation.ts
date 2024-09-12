import { useCallback } from 'react';
import { useDispatch } from 'react-redux';

import { selectConversation, selectIm, setConversation } from '../store/imReducers';
import { useAppSelector } from '../store/hooks';

export const useLiveConversation = () => {
  const instance = useAppSelector(selectIm);
  const oldConversation = useAppSelector(selectConversation);
  const dispatch = useDispatch();

  const setCurrentConversation = useCallback(
    async ({ id, shortId, type }) => {
      if (oldConversation && id === oldConversation.id) {
        return;
      }
      const newCurrentConversation = await instance.getConversationOnline({
        conversationId: id,
        shortId,
        type
      });
      if (!newCurrentConversation) {
        return;
      }
      dispatch(setConversation(newCurrentConversation));
    },
    [oldConversation, instance, dispatch]
  );

  return {
    setCurrentConversation
  };
};

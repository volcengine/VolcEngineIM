import { useCallback } from 'react';
import { useDispatch } from 'react-redux';

import { selectConversation, selectIm, setConversation } from '../store/imReducers';
import { useAppSelector } from '../store/hooks';

export const useConversation = () => {
  const instance = useAppSelector(selectIm);
  const oldConversation = useAppSelector(selectConversation);
  const dispatch = useDispatch();

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

  return {
    setCurrentConversation
  };
};

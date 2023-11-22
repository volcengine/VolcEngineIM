import { useSetRecoilState } from 'recoil';
import { CurrentConversation, IsMuted, LiveConversationOwner } from '../store';

export const useLive = () => {
  const setCurrentConversation = useSetRecoilState(CurrentConversation);
  const setIsMuted = useSetRecoilState(IsMuted);
  const setLiveConversationOwner = useSetRecoilState(LiveConversationOwner);

  const clearCurrentLiveConversationStatus = (isAll = true) => {
    if (isAll) {
      setCurrentConversation(null);
    }
    setIsMuted(undefined);
    setLiveConversationOwner(undefined);
  };

  return {
    clearCurrentLiveConversationStatus,
  };
};

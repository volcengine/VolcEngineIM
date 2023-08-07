import { useSetRecoilState } from 'recoil';
import { CurrentConversation, IsMuted, LiveConversationNickName, LiveConversationOwner } from '../store';

export const useLive = () => {
  const setCurrentConversation = useSetRecoilState(CurrentConversation);
  const setIsMuted = useSetRecoilState(IsMuted);
  const setLiveConversationOwner = useSetRecoilState(LiveConversationOwner);
  const setLiveConversationNickName = useSetRecoilState(LiveConversationNickName);

  const clearCurrentLiveConversationStatus = (isAll = true) => {
    if (isAll) {
      setCurrentConversation(null);
    }
    setIsMuted(undefined);
    setLiveConversationOwner(undefined);
    setLiveConversationNickName(undefined);
  };

  return {
    clearCurrentLiveConversationStatus,
  };
};

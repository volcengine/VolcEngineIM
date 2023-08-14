import { IMEvent } from '@volcengine/im-web-sdk';
import { useRequest } from 'ahooks';
import { useEffect } from 'react';
import { BytedIMInstance } from '../store';
import { useRecoilValue } from 'recoil';

export function useUnreadFriendApplyCount() {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const { data: unreadApplyCount = 0, refresh } = useRequest(
    async () => {
      const resp = await bytedIMInstance.getFriendReceiveApplyListOnline({});
      return resp.unreadCount;
    },
    {
      debounceWait: 1000,
    }
  );

  useEffect(() => {
    let handler = () => {
      refresh();
    };
    let sub1 = bytedIMInstance.event.subscribe(IMEvent.FriendApplyRead, handler);
    let sub2 = bytedIMInstance.event.subscribe(IMEvent.FriendApply, handler);
    return () => {
      bytedIMInstance.event.unsubscribe(IMEvent.FriendApplyRead, sub1);
      bytedIMInstance.event.unsubscribe(IMEvent.FriendApply, sub2);
    };
  }, []);

  return unreadApplyCount;
}

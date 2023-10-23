import { useUpdate } from 'ahooks';
import { useEffect } from 'react';

export function useFriendAlias() {
  const update = useUpdate();
  useEffect(() => {
    window.addEventListener('friendRefresh', () => {
      update();
    });
  }, []);
}

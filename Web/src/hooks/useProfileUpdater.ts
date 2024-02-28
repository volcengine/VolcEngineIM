import { useDebounce, useDebounceFn, useUpdate } from 'ahooks';
import { useEffect, useRef } from 'react';
import { useRecoilState } from 'recoil';
import { AccountsInfoVersion, BytedIMInstance } from '../store';
import { ACCOUNTS_INFO, PROFILE } from '../constant';

const pending = new Map<string, { force: boolean }>();
export function useProfileUpdater() {
  const [bytedIMInstance, setBytedIMInstance] = useRecoilState(BytedIMInstance);
  const [accountsInfo, setAccountsInfo] = useRecoilState(AccountsInfoVersion);

  const request = useDebounceFn(
    async () => {
      let profileStore = PROFILE.value;
      const ids = [...pending.keys()].filter(id => pending.get(id).force || !profileStore[id]?.profile);
      pending.clear();
      while (ids.length) {
        const r = await bytedIMInstance.getUserProfilesOnline({ userIds: ids.splice(0, 30) });
        r.list.forEach(x => {
          profileStore[x.userId] = { lastSeen: Date.now(), profile: x };
        });
        r.failedUids.forEach(x => {
          profileStore[x] = { lastSeen: Date.now() };
        });
        setAccountsInfo(v => v + 1);
      }
    },
    {
      wait: 500,
    }
  );

  useEffect(() => {
    let listener1 = async (e: CustomEvent) => {
      const users = e.detail.userIds;
      users.forEach((id: string) => {
        pending.set(id, { force: pending.get(id)?.force || Boolean(e.detail.force) });
      });
      request.run();
    };
    let listener2 = async (e: CustomEvent) => {
      setAccountsInfo(v => v + 1);
    };
    window.addEventListener('profileRequest', listener1);
    window.addEventListener('friendRefresh', listener2);

    return () => {
      window.removeEventListener('profileRequest', listener1);
      window.removeEventListener('friendRefresh', listener2);
    };
  }, [bytedIMInstance]);
}

export function useAccountsInfo() {
  const [accountsInfo, setAccountsInfo] = useRecoilState(AccountsInfoVersion);

  return ACCOUNTS_INFO;
}

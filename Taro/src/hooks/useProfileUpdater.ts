import { useEffect, useRef } from 'react';
import { AccountsInfoVersion, BytedIMInstance } from '../store';

import { ACCOUNTS_INFO, PROFILE } from '../utils/account';
import Taro from '@tarojs/taro';
import { useRecoilState } from 'recoil';
import { useDebounceFn } from '@taro-hooks/ahooks';

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
      wait: 500
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
    Taro.eventCenter.on('profileRequest', listener1);
    Taro.eventCenter.on('friendRefresh', listener2);

    return () => {
      Taro.eventCenter.off('profileRequest', listener1);
      Taro.eventCenter.off('friendRefresh', listener2);
    };
  }, [bytedIMInstance]);
}

export function useAccountsInfo() {
  const [accountsInfo, setAccountsInfo] = useRecoilState(AccountsInfoVersion);

  return ACCOUNTS_INFO;
}

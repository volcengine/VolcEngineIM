import {
  USER_ID_KEY,
  IM_TOKEN_KEY,
  BUSINESS_BACKEND_DOMAIN,
  ACCOUNT_CHECK_ENABLE,
  BUSINESS_BACKEND_TOKEN_ENABLE,
  IM_TOKEN_EXPIRED_SECONDS,
} from '../constant';
import request from './request';
import { Storage } from '../utils/storage';
import * as JSONLong from 'json-long';
import Long from 'long';

export const fetchToken = <T>(data: { appId: number; userId?: string; userIDString?: string }) => {
  const { appId, userId, userIDString } = data;
  if (BUSINESS_BACKEND_TOKEN_ENABLE) {
    const expire = Date.now() + IM_TOKEN_EXPIRED_SECONDS * 1000;
    let params;
    if (userIDString) {
      params = `&userIDString=${userIDString}`;
    } else {
      params = `&userID=${userId}`;
    }
    return request.get<T, { Token: string; userId: string }>(
      `${BUSINESS_BACKEND_DOMAIN}/get_token?appID=${appId}&expire=${expire}${params}`
    );
  } else {
    return { Token: Storage.get(IM_TOKEN_KEY).content as string, userId: data.userId };
  }
};

export const fetchUserId = async () => {
  return new Promise(resolve => {
    setTimeout(() => {
      const { content: cacheUserId } = Storage.get(USER_ID_KEY);
      resolve(cacheUserId);
    }, 50);
  });
};

let allExistRecord = new Proxy(
  {},
  {
    get: function () {
      return true;
    },
  }
);

export async function checkAccount<T>(data: {
  uids: string[];
  useString?: boolean;
}): Promise<Record<string, boolean | undefined>> {
  const { uids, useString } = data;
  return allExistRecord;
  if (!ACCOUNT_CHECK_ENABLE) return allExistRecord;

  const result: Record<string, boolean | undefined> = {};
  try {
    const data = useString
      ? {
          uids: [],
          ext: {
            's:Uids': JSON.stringify(uids),
          },
        }
      : {
          uids: uids.map(i => Long.fromString(i)),
        };

    const resp = await request.post<T, { account_base_infos: { create_time: number }[] }>(
      `${BUSINESS_BACKEND_DOMAIN}/check_account`,
      JSONLong.stringify({
        token: Storage.get(IM_TOKEN_KEY).content,
        ...data,
      })
    );
    let infos = resp?.account_base_infos ?? [];
    for (let [index, info] of infos.entries()) {
      if (info?.create_time) {
        result[uids[index]] = true;
      }
    }
    return result;
  } catch {
    return {};
  }
}

export async function deleteAccount<T>(): Promise<Record<string, boolean | undefined>> {
  const resp = await request.post<T, {}>(
    `${BUSINESS_BACKEND_DOMAIN}/cancel_account`,
    JSONLong.stringify({ token: Storage.get(IM_TOKEN_KEY).content })
  );
  return resp;
}

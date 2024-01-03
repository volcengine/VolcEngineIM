export const APP_ID =  0; // 更换为自己的 APP_ID
export const BUSINESS_BACKEND_DOMAIN =
   ''; // 业务后端域名（选填，IM Token 应由后端生成，如暂无业务后端接口可使用控制台 Token 生成工具）

import { Friend, im_proto, UserProfile } from '@volcengine/im-web-sdk';
import DefaultAvatar from '../assets/images/default_avatar.png';

// @ts-ignore
if (APP_ID === 0) {
  let msg = '请在 src/constant/index.ts 配置自己的 APP_ID';
  alert(msg);
  throw new Error(msg);
}

export enum KeyCode {
  ESC = 27,
  TAB = 9,
  ENTER = 13,
  CTRL = 17,
  A = 65,
  P = 80,
  N = 78,
  F = 70,
  B = 66,
  LEFT = 37,
  UP = 38,
  RIGHT = 39,
  DOWN = 40,
  BACKSPACE = 8,
  SPACE = 32,
  RETURN = 13,
}

export enum EDITOR_TYPE {
  SIMPLE = 'SIMPLE',
  POST = 'POST',
  SIMPLE_REPLY = 'SIMPLE_REPLY',
  POST_REPLY = 'POST_REPLY',
  CAN_NOT_EDIT = 'CAN_NOT_EDIT',
}

export enum ROLE {
  Normal = 0,
  Owner = 1,
  Manager = 2,
}

export const USER_ID_KEY = 'IM_USER_ID_KEY';
export const IM_TOKEN_KEY = 'IM_TOKEN_KEY';

let SDK_CONFIG_ONLINE = {
  appId: APP_ID,
  authType: im_proto.AuthType.TOKEN_AUTH,
  debug: true,
  apiUrl: 'https://imapi.volcvideo.com',
  frontierUrl: 'wss://frontier-sinftob.ivolces.com/ws/v2',
};



export const BUSINESS_BACKEND_TOKEN_ENABLE = Boolean(BUSINESS_BACKEND_DOMAIN);

export const SMS_ENABLE =  false;
export const ACCOUNT_CHECK_ENABLE =
   false;

export const ENABLE_LIVE_DEMO =
   false;

export const SDK_OPTION =
   SDK_CONFIG_ONLINE;

export const FRIEND_INFO: { value: { [k: string]: Friend } } = { value: {} };

export const PROFILE: {
  value: {
    [k: string]: {
      lastSeen: number;
      profile?: UserProfile;
    };
  };
} = {
  value: {},
};

export const ACCOUNTS_INFO = new Proxy(
  {} as {
    [id: string]: {
      id: string;
      /* 好友备注，realName */ name: string;
      url: string;
      /* 用户昵称，默认名称 */ realName: string;
      hasFriendAlias: boolean;
    };
  },
  {
    get: function (target, id: string) {
      if (!target[id]) {
        let last = Number(id[id.length - 1]) % 10;
        if (last === 0) last = 10;
        if (!PROFILE.value[id]) {
          window.dispatchEvent(
            new CustomEvent('profileRequest', {
              detail: { userIds: [id] },
            })
          );
        }

        let realName = PROFILE.value[id]?.profile?.nickname || `用户${id}`;
        let friendAlias = FRIEND_INFO.value[id]?.alias;
        return {
          id: id,
          name: friendAlias ? friendAlias : realName,
          hasFriendAlias: Boolean(friendAlias),
          realName: realName,
          url: PROFILE.value[id]?.profile?.portrait || DefaultAvatar,
        };
      }
      return target[id];
    },
  }
);

export enum CheckCode {
  SENSITIVE_WORDS = 500,
}

export const EXT_ALIAS_NAME = 'a:live_group_member_alias_name';
export const EXT_AVATAR_URL = 'a:live_group_member_avatar_url';

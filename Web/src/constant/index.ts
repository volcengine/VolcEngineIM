export const APP_ID =  0; // 更换为自己的 APP_ID
export const BUSINESS_BACKEND_DOMAIN =
   ''; // 业务后端域名（选填，IM Token 应由后端生成，如暂无业务后端接口可使用控制台 Token 生成工具）

import { im_proto } from '@volcengine/im-web-sdk';
import User_01 from '../assets/images/user_01.png';
import User_02 from '../assets/images/user_02.png';
import User_03 from '../assets/images/user_03.png';
import User_04 from '../assets/images/user_04.png';
import User_05 from '../assets/images/user_05.png';
import User_06 from '../assets/images/user_06.png';
import User_07 from '../assets/images/user_07.png';
import User_08 from '../assets/images/user_08.png';
import User_09 from '../assets/images/user_09.png';
import User_10 from '../assets/images/user_10.png';

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

const AVATAR_MAP = {
  1: User_01,
  2: User_02,
  3: User_03,
  4: User_04,
  5: User_05,
  6: User_06,
  7: User_07,
  8: User_08,
  9: User_09,
  10: User_10,
};

export const ACCOUNTS_INFO = new Proxy({} as { [id: string]: { id: string; name: string; url: string } }, {
  get: function (target, id: string) {
    if (!target[id]) {
      let last = Number(id[id.length - 1]) % 10;
      if (last === 0) last = 10;
      return {
        id: id,
        name: `用户${id}`,
        url: AVATAR_MAP[last],
      };
    }
    return target[id];
  },
});

export enum CheckCode {
  SENSITIVE_WORDS = 500,
}

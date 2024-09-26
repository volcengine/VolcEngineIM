import { User } from './interface';
import * as IMLib from '@volcengine/im-mp-sdk';

export const APP_ID =  666675;

// imcloud 配置
export const IMCLOUD_CONFIG = {
  appId: APP_ID,
  authType: IMLib.im_proto.AuthType.TOKEN_AUTH,
  debug: true,
  timeout: 5000,
  apiUrl: 'https://imapi.volcvideo.com',
  frontierUrl: 'wss://frontier-sinftob.ivolces.com/ws/v2',
  tokenDomain:  'https://imapi.volcvideo.com/imcloud'
};

// 用户
export const USER_LIST = new Map<string, User>([
  [
    '10001',
    {
      id: '10001',
      name: '用户1'
    }
  ],
  [
    '10002',
    {
      id: '10002',
      name: '用户2'
    }
  ],
  [
    '10003',
    {
      id: '10003',
      name: '用户3'
    }
  ],
  [
    '10004',
    {
      id: '10004',
      name: '用户4'
    }
  ],
  [
    '10005',
    {
      id: '10005',
      name: '用户5'
    }
  ]
]);



// 事件
export const EVENT_INIT_FINISH = 'init-finish';
export const EVENT_CONVERSATION_CHANGE = 'conversation-change';
export const EVENT_MESSAGE_UPSERT = 'message-upsert';

// cdn 图片
export const OTHER_AVATAR = 'https://img2.woyaogexing.com/2022/12/18/5bd7a9cc832ef9171ad0fbef9319c012.jpeg';
export const ME_AVATAR = 'https://img2.woyaogexing.com/2022/12/18/03af1f3aede43551745677558f3409c5.jpeg';
export const CONVERSATION_GROUP_AVATAR =
  'https://lf3-static.bytednsdoc.com/obj/eden-cn/ild_jw_upfbvk_lm/ljhwZthlaukjlkulzlp/imcloud/group-chat.png';
export const CONVERSATION_SINGLE_AVATAR =
  'https://lf3-static.bytednsdoc.com/obj/eden-cn/ild_jw_upfbvk_lm/ljhwZthlaukjlkulzlp/imcloud/single-chat.png';
export const EXT_ALIAS_NAME = 'a:live_group_member_alias_name';
export const EXT_AVATAR_URL = 'a:live_group_member_avatar_url';
export const EXT_COUPON_STATUS = 'a:coupon_status';

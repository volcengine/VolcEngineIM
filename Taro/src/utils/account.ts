import Taro from '@tarojs/taro';
import { Friend, im_proto, UserProfile } from '@volcengine/im-mp-sdk';
import DefaultAvatar from '../assets/images/default_avatar.png';
import GroupIcon from '../assets/images/group_icon.png';
export const FRIEND_INFO: { value: { [k: string]: Friend } } = { value: {} };

export const PROFILE: {
  value: {
    [k: string]: {
      lastSeen: number;
      profile?: UserProfile;
    };
  };
} = {
  value: {}
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
          Taro.eventCenter.trigger('profileRequest', {
            detail: { userIds: [id] }
          });
        }

        let realName = PROFILE.value[id]?.profile?.nickname || `用户${id}`;
        let friendAlias = FRIEND_INFO.value[id]?.alias;
        return {
          id: id,
          name: friendAlias ? friendAlias : realName,
          hasFriendAlias: Boolean(friendAlias),
          realName: realName,
          url: PROFILE.value[id]?.profile?.portrait || DefaultAvatar
        };
      }
      return target[id];
    }
  }
);

export const getConversationAvatar = conversation => {
  if (conversation.type === im_proto.ConversationType.GROUP_CHAT) {
    return GroupIcon;
  }
  if (conversation.type === im_proto.ConversationType.MASS_CHAT) {
    return GroupIcon;
  }
  return ACCOUNTS_INFO[conversation?.toParticipantUserId]?.url;
};

export const getConversationName = conversation => {
  console.log('getConversationName', conversation);
  const { type, coreInfo, toParticipantUserId } = conversation;
  if (type === im_proto.ConversationType.GROUP_CHAT) {
    return coreInfo.name || '未命名群聊';
  } else if (type === im_proto.ConversationType.ONE_TO_ONE_CHAT) {
    return ACCOUNTS_INFO[toParticipantUserId]?.name;
  } else if (type === im_proto.ConversationType.MASS_CHAT) {
    return coreInfo.name || '未命名直播群';
  }
  return '未知群';
};

import React from 'react';
import { im_proto, Message, FlightStatus } from '@volcengine/im-web-sdk';
import { IconLoading } from '@arco-design/web-react/icon';

import * as PCIcon from '../components/Icon';
import { ACCOUNTS_INFO } from '../constant';
import GroupIcon from '../assets/images/group_icon.png';

export enum customType {
  volc = 1,
  system = 2,
  coupon = 3,
}

const MsgStatusElePC = {
  [FlightStatus.Inflight]: {
    status: FlightStatus.Inflight,
    icon: <IconLoading />,
  },
  [FlightStatus.Failed]: {
    status: FlightStatus.Failed,
    icon: <PCIcon.IconSendFailed />,
  },
  // [MessageStatus.Read]: {
  //   content: '已读',
  //   icon: <PCIcon.IconHasRead />,
  // },
  // [MessageStatus.UnRead]: {
  //   content: '未读',
  //   icon: <PCIcon.IconUnRead />,
  // },
};

export const getHeaderTitle = (originStr?: string, unReadTotal?: number, maxNum = 99) => {
  let totalStr: string = originStr || '';

  if (!unReadTotal || unReadTotal <= 0) {
    return totalStr;
  }

  let str = unReadTotal > maxNum ? `（${unReadTotal}）+` : `（${unReadTotal}）`;
  totalStr += str;

  return totalStr;
};

export const ErrorMessageStatus = [FlightStatus.Failed, FlightStatus.Rejected];

export const getMsgStatus = (status: FlightStatus) => {
  let msgStatus: FlightStatus;

  if (ErrorMessageStatus.includes(status)) {
    msgStatus = FlightStatus.Failed;
  } else if (status >= FlightStatus.Created && status <= FlightStatus.Inflight) {
    msgStatus = FlightStatus.Inflight;
  }

  return msgStatus;
};

export const getMsgStatusIcon = (status: FlightStatus) => {
  const msg: {
    status?: FlightStatus;
    icon?: React.ReactNode;
  } = MsgStatusElePC[getMsgStatus(status)];

  return msg;
};

export const parseMessageContent = (msg: Message) => {
  let content: any = {};

  try {
    content = JSON.parse(msg.content);
  } catch (error) {
    console.log('invalid json content: ', msg.content);
  }

  return content;
};

export const checkMetoMe = (conversationId?: string) => {
  if (!conversationId) {
    return false;
  }

  const conversationParticipant = conversationId.split(':').slice(-2);

  return conversationParticipant?.[0] === conversationParticipant?.[1];
};

export const getMessagePreview = (msg: Message): string => {
  if (!msg) {
    return '';
  }
  const { content, type, isRecalled } = msg;
  if (isRecalled) {
    return getRecalledMsgDesc(msg);
  }
  switch (type) {
    case im_proto.MessageType.MESSAGE_TYPE_TEXT:
      try {
        let { text } = JSON.parse(content);
        try {
          text = JSON.parse(text).innerText ?? text;
        } catch (e) {}
        return text ?? content;
      } catch (e) {
        return content;
      }
    case im_proto.MessageType.MESSAGE_TYPE_AUDIO:
      return '[语音]';
    case im_proto.MessageType.MESSAGE_TYPE_VIDEO:
    case im_proto.MessageType.MESSAGE_TYPE_VIDEO_V2:
      return '[视频]';
    case im_proto.MessageType.MESSAGE_TYPE_IMAGE:
      return '[图片]';
    case im_proto.MessageType.MESSAGE_TYPE_FILE:
      return '[文件]';
    case im_proto.MessageType.MESSAGE_TYPE_CUSTOM:
      try {
        let { type } = JSON.parse(content);
        if (Number(type) === customType.system) {
          return '[系统消息]';
        }
      } catch (e) {}
      return '[自定义消息]';
    default:
      return '未知类型消息';
  }
};

export const getConversationName = conversation => {
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

export const getConversationLastMsgDesc = conversation => {
  const { type, lastMessage } = conversation;
  if (!lastMessage) {
    return '';
  }
  if (type === im_proto.ConversationType.ONE_TO_ONE_CHAT || isSystemMsgType(lastMessage)) {
    return getMessagePreview(lastMessage);
  } else {
    return `${ACCOUNTS_INFO[lastMessage.sender]?.name}: ${getMessagePreview(lastMessage)}`;
  }
};

export const getConversationAvatar = conversation => {
  if (conversation.type === im_proto.ConversationType.GROUP_CHAT) {
    return GroupIcon;
  }
  if (conversation.type === im_proto.ConversationType.MASS_CHAT) {
    return GroupIcon;
  }
  return ACCOUNTS_INFO[conversation?.toParticipantUserId]?.url;
};

export const isSystemMsgType = (msg: Message) => {
  const { type, content } = msg;
  if (type === im_proto.MessageType.MESSAGE_TYPE_CUSTOM) {
    let contentObj: any = {};
    try {
      contentObj = JSON.parse(content);
    } catch (err) {
      return false;
    }
    if (Number(contentObj.type) === customType.system) {
      return true;
    }
  }
  return false;
};

export const getRecalledMsgDesc = (message: Message) => {
  const { conversationType, isFromMe, sender } = message;
  let content = '';
  if (isFromMe) {
    content = '你撤回了一条消息 ';
  } else if (conversationType === im_proto.ConversationType.ONE_TO_ONE_CHAT) {
    content = '对方撤回了一条消息';
  } else if (conversationType === im_proto.ConversationType.GROUP_CHAT) {
    content = `${ACCOUNTS_INFO[sender]?.name}撤回了一条消息`;
  } else {
    content = '消息已被撤回';
  }
  return content;
};

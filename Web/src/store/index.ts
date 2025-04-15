import React from 'react';
import { atom } from 'recoil';
import { BytedIM, Conversation, FileInfo, im_proto, Message, Participant } from '@volcengine/im-web-sdk';

import { IScrollViewRef } from '../components/MessageList';
import { Storage } from '../utils';
import { USER_ID_KEY } from '../constant';
import { EmojiTypes, IMAccountInfoTypes, IMAccountsTypes, BlockItem } from '../types';

const { content: cacheUserId } = Storage.get(USER_ID_KEY);

const UserId = atom({
  key: 'UserId',
  default: String(cacheUserId),
});

const UserName = atom({
  key: 'UserName',
  default: '',
});

const DefaultUserIds = atom({
  key: 'DefaultUserIds',
  default: ['10001', '10002', '10003', '10004', '10005', '10006', '10007', '10008', '10009', '10010'],
});

const BytedIMInstance = atom<BytedIM>({
  key: 'BytedIMInstance',
  default: null,
  dangerouslyAllowMutability: true,
});

const Conversations = atom<Array<Conversation>>({
  key: 'Conversations',
  default: [],
  dangerouslyAllowMutability: true,
});

const CurrentConversation = atom<Conversation | undefined>({
  key: 'CurrentConversation',
  default: undefined,
  dangerouslyAllowMutability: true,
});

const CurrentConversationUnreadCount = atom<number>({
  key: 'CurrentConversationUnreadCount',
  default: 0,
  dangerouslyAllowMutability: true,
});

const Messages = atom<Array<Message>>({
  key: 'Messages',
  default: [],
  dangerouslyAllowMutability: true,
});

const Participants = atom<Array<Participant>>({
  key: 'Participants',
  default: [],
  dangerouslyAllowMutability: true,
});

const UnReadTotal = atom<number>({
  key: 'UnReadTotal',
  default: null,
  dangerouslyAllowMutability: true,
});

const IMEmoji = atom<EmojiTypes>({
  key: 'IMEmoji',
  default: [],
  dangerouslyAllowMutability: true,
});

const AccountsInfo = atom<IMAccountsTypes>({
  key: 'AccountsInfo',
  default: new Map(),
  dangerouslyAllowMutability: true,
});

const CurAccountsInfo = atom<IMAccountInfoTypes>({
  key: 'CurAccountsInfo',
  default: null,
  dangerouslyAllowMutability: true,
});

/** 引用的消息 */
const ReferenceMessage = atom<Message>({
  key: 'ReferenceMessage',
  default: null,
  dangerouslyAllowMutability: true,
});

/** 正在二次编辑的消息 */
export const EditMessage = atom<Message>({
  key: 'EditMessage',
  default: null,
  dangerouslyAllowMutability: true,
});

const UserBlockList = atom<BlockItem[]>({
  key: 'UserBlockList',
  default: [],
  dangerouslyAllowMutability: true,
});

const ScrollRef = atom<React.RefObject<IScrollViewRef>>({
  key: 'ScrollRef',
  default: null,
  dangerouslyAllowMutability: true,
});

const FileUploadProcessStore = atom<{ [k: string]: Parameters<FileInfo['onUploadProcess']>[0] | undefined }>({
  key: 'FileUploadProcess',
  default: {},
  dangerouslyAllowMutability: true,
});

const LiveConversations = atom<Array<Conversation>>({
  key: 'LiveConversations',
  default: [],
  dangerouslyAllowMutability: true,
});

const IsMuted = atom<boolean | undefined>({
  key: 'IsMuted',
  default: undefined,
  dangerouslyAllowMutability: true,
});

const LiveConversationMemberCount = atom<number | undefined>({
  key: 'LiveConversationMemberCount',
  default: undefined,
  dangerouslyAllowMutability: true,
});

const LiveConversationOwner = atom<string | undefined>({
  key: 'LiveConversationOwner',
  default: undefined,
  dangerouslyAllowMutability: true,
});

const SendMessagePriority = atom<im_proto.MessagePriority>({
  key: 'SendMessagePriority',
  default: im_proto.MessagePriority.NORMAL,
  dangerouslyAllowMutability: true,
});

const AccountsInfoVersion = atom<im_proto.MessagePriority>({
  key: 'AccountsInfoVersion',
  default: 0,
  dangerouslyAllowMutability: true,
});

const ReadReceiptVersion = atom({
  key: 'ReadReceiptVersion',
  default: 0,
});

const ClearBotContextMessages = atom<string[]>({
  key: 'ClearBotContextMessages',
  default: [],
});
// const DeleteSpecialBotConv = atom<boolean>({
//   key: 'DeleteSpecialBotConv',
//   default: false,
// });
const SpecialBotConvStickOnTop = atom<boolean>({
  key: 'SpecialBotConvStickOnTop',
  default: true,
});

export {
  UserId,
  DefaultUserIds,
  ScrollRef,
  FileUploadProcessStore,
  UserBlockList,
  CurAccountsInfo,
  IMEmoji,
  AccountsInfo,
  ReferenceMessage,
  UnReadTotal,
  Messages,
  Participants,
  CurrentConversation,
  Conversations,
  BytedIMInstance,
  UserName,
  CurrentConversationUnreadCount,
  LiveConversations,
  IsMuted,
  LiveConversationMemberCount,
  LiveConversationOwner,
  SendMessagePriority,
  AccountsInfoVersion,
  ReadReceiptVersion,
  ClearBotContextMessages,
  // DeleteSpecialBotConv,
  SpecialBotConvStickOnTop,
};

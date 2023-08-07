import React from 'react';
import { Message } from '@volcengine/im-web-sdk';

export * from './actions';

export interface MessageItemType extends Message {
  isTimeVisible?: boolean;
}

export interface IparticipantsType {
  id: string /** 要创建聊天的对象用户id */;
  name?: string /** 要创建聊天的对象用户名字 */;
  avatar?: string /** 要创建聊天的对象用户头像 */;
}

// 是否考虑移动和PC分开，但是根据业务，可以抽象一个大骨架
export interface Iui {
  conversationHeader?: React.ReactNode;
  conversationItem?: React.ReactNode;
  chatHeader?: React.ReactNode;
  messageItem?: React.ReactNode;
  noMessage?: React.ReactNode;
  chatOperation?: React.ReactNode;
  chatStatus?: React.ReactNode;
  messageTip?: React.ReactNode;
  noPermission?: React.ReactNode;
  appNavbar?: React.ReactNode;
}

export interface IuiMobile {}

export interface IuiPC {}

export enum RtcStatus {
  'Init' = 0 /** 初始状态 */,
  'Ringing' = 1 /** 主动呼叫响铃中 */,
  'SelfRinging' = 2 /** 被呼叫响铃中 */,
  'Online' = 3 /** 聊天中 */,
  'End' = 4 /** 结束 */,
  'Error' = -1 /** 异常 */,
}

/** 消息发送状态 */
export enum MessageStatus {
  /** 消息已经创建 */
  Created = 0,

  /** 准备中 (图片正在上传等) */
  Preparing = 1,

  /** 发送中 (已经提交请求, 尚未收到响应) */
  Inflight = 2,

  /** 发送成功 (已经收到响应) */
  Succeeded = 3,

  Received = 4,

  /** 已读 真实消息没有该类型 */
  Read = 9,

  /** 未读 真实消息没有该类型 */
  UnRead = 10,

  /** 发送失败 (网络错误, 内部错误等) */
  Failed = -1,

  /** 消息被服务端拒绝 (回调检查) */
  Rejected = -2,

  /** 消息被自见 */
  SelfVisible = -3,
}

export interface EmojiItemTypes {
  key?: string;
  emoji?: string;
}

export type EmojiTypes = EmojiItemTypes[];

export enum ImAccountType {
  /** 达人 */
  Kol = 0,
  /** 店铺 */
  Shop = 1,
}

// im账号基本信息
export interface IMAccountInfoTypes {
  im_id?: string /** 账号 */;
  im_type?: ImAccountType;
  biz_account_id?: string /** 账户id: 目前只返回商家shop_id */;
  avatar?: string /** 头像 */;
  nickname?: string /** 昵称 */;
  profile_url?: string /** 跳转到个人页/店铺页链接 */;
}

// key im_id
export type IMAccountsTypes = Map<string, IMAccountInfoTypes>;

export interface GetAccountResTypes {
  data?: {
    [props: string]: IMAccountInfoTypes;
  };
  log_id?: string;
  code?: number;
  msg?: string;
}
export interface BlockItem {
  userId: string;
  createTime: string;
}
// 都是业务相关，不应该放这里...
// 0: 正常 非0:账号异常
export enum ImAccountStatus {
  /** 正常 */
  Normal = 0,
  /** 百应账户异常 */
  ByAbnormal = 1,
  /** im账号异常 */
  ImAbnormal = 2,
  /** 达人电商权限异常 */
  PermissionsAbnormal = 3,
}

export interface KolProfile {
  /** 达人等级 */
  kol_level?: number;
  /** 达人粉丝数(类型待定) */
  fans_num?: string;
  /** 达人口碑分 */
  reputation_score?: string;
  /** 跳转到个人页链接 */
  profile_url?: string;
}

export interface ShopProfile {
  /** 体验分 */
  exper_score?: string;
  /** 月销量 */
  monthly_sales?: string;
  /** 跳转到店铺页链接 */
  profile_url?: string;
}

export interface ImProfile {
  /** im账号类型 */
  im_type?: ImAccountType;
  /** im账号状态 */
  im_account_status?: ImAccountStatus;
  /** 达人基本信息 */
  kol_profile?: KolProfile;
  /** 商家基本信息 */
  shop_profile?: ShopProfile;
}

export interface GetProfileResTypes {
  log_id?: string;
  code?: number;
  msg?: string;
  data?: ImProfile;
}

export enum ErrorType {
  MPVolumeExceedUpperLimit = 10006,
}

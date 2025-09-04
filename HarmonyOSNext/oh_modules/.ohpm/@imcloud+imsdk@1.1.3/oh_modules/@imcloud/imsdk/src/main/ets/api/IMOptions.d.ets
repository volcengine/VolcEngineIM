import { HttpBodyMode, HttpContentType, NetType } from './const/consts';
import { im_proto } from './proto';
/**
 * IMSDK配置项
 */
export interface IMOption {
    debug: boolean;
    appId: number;
    appName: string;
    token: string;
    deviceId: string;
    iid: string;
    userId: string;
    userIdBigint: bigint;
    payloadLength: number;
    netType: NetType;
    httpContentType: HttpContentType;
    httpDataMode: HttpBodyMode;
    maxWsRetryTimes: number;
    maxHttpRetryTimes: number;
    wsRequestTimeout: number;
    httpRequestTimeout: number;
    inboxTypes: number[];
    supportInboxType: number[];
    authType: im_proto.AuthType;
    httpHost: string;
    channel: string;
    service: number;
    method: number;
    enableConversationBox: boolean;
    useServerTime: boolean;
    enableFoldedBox: boolean;
    isEnableTransformReaderList: boolean;
    enableNotDisplayConversation: boolean;
    enableFilterSortOrder: boolean;
    stickTopByLastMsgTime: boolean;
    biz: string;
    secUid: string;
    headers: Map<string, string>;
    requestHeaders: Map<string, string>;
    maxSendMsgRetryTimes: number;
    enableCheckMinIndex: boolean;
    msgReadStatusMinNetRequestInterval: number;
    maxStrangerCountPerRefresh: number;
    /**
     * 已读成员数量， 是否需要考虑新进入群的成员，看不到历史消息这种情况
     * true 表示新进群的看不到历史消息， 那么消息的已读数量里面不增加新入群的人。
     * false 表示 不care 是否是新入群，是否能看到历史消息， 只要成员堵了新消息则表示所有的消息都读了。
     */
    isNewMemberCalculateInRead: boolean;
    /**
     * 若不为null，在获取会话已读信息时，只会拉取bizRole等于该数组的成员。
     * key: inbox
     * value: 对应member角色的bizRole
     */
    bizRoleWhenFetchConvReadInfo: Map<number, string[]>;
    /**
     * 是否启用分inboxType来进行已读信息查询，抖音中默认不走
     */
    enableDistributeInboxTypeToGetReadInfo: boolean;
    maxPullToOldWhenRepair: number;
    searchLastHintMessagePageSize: number;
    pullTimesFromNewToOld: number;
    devicePlatform: string;
    deviceType: string;
    os: string;
    osVersion: string;
    versionCode: number;
    versionName: string;
    sessionId?: string;
    boe: boolean | string;
    ppe: string;
    enablePullContentTrimmedMsg: boolean;
    /**
     * 使用sendIgnoreTicket
     */
    sendIgnoreTicket: boolean;
    /**
     * 混链拉取否启用从新到旧拉取
     */
    enableRecentLinkNewToOld: boolean;
    /**
     * 初始化后是否需要拉混链
     */
    needGetMsgByUser: boolean;
    cert?: string | false;
    tsSign?: string | false;
}
export declare class IMOptions implements IMOption {
    debug: boolean;
    appId: number;
    appName: string;
    token: string;
    deviceId: string;
    iid: string;
    userId: string;
    userIdBigint: bigint;
    payloadLength: number;
    netType: NetType;
    httpContentType: HttpContentType;
    httpDataMode: HttpBodyMode;
    maxWsRetryTimes: number;
    maxHttpRetryTimes: number;
    wsRequestTimeout: number;
    httpRequestTimeout: number;
    inboxTypes: number[];
    supportInboxType: number[];
    authType: im_proto.AuthType;
    isEnableTransformReaderList: boolean;
    msgReadStatusMinNetRequestInterval: number;
    httpHost: string;
    channel: string;
    service: number;
    method: number;
    os: string;
    enableConversationBox: boolean;
    useServerTime: boolean;
    enableCheckMinIndex: boolean;
    enableFoldedBox: boolean;
    enableNotDisplayConversation: boolean;
    enableFilterSortOrder: boolean;
    stickTopByLastMsgTime: boolean;
    isNewMemberCalculateInRead: boolean;
    bizRoleWhenFetchConvReadInfo: Map<number, string[]>;
    enableDistributeInboxTypeToGetReadInfo: boolean;
    biz: string;
    secUid: string;
    headers: Map<string, string>;
    requestHeaders: Map<string, string>;
    maxSendMsgRetryTimes: number;
    maxStrangerCountPerRefresh: number;
    maxPullToOldWhenRepair: number;
    pullTimesFromNewToOld: number;
    searchLastHintMessagePageSize: number;
    devicePlatform: string;
    deviceType: string;
    osVersion: string;
    versionCode: number;
    versionName: string;
    sessionId?: string;
    boe: string | boolean;
    ppe: string;
    enablePullContentTrimmedMsg: boolean;
    sendIgnoreTicket: boolean;
    enableRecentLinkNewToOld: boolean;
    needGetMsgByUser: boolean;
    cert?: string | false;
    tsSign?: string | false;
}

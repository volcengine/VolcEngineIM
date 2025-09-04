import { Message } from '../api/model/Message';
import { im_proto } from '../api/proto';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { SendMsgHandler } from '../handler/message/SendMsgHandler';
export declare class WaitChecker extends IMSdkBaseObject {
    private sWaitingAsyncRespMsgSet;
    private sInitingBoxQueue;
    private sWaitConversationInfoMap;
    private sWaitConversationSubInfoMap;
    private sGettingConversationSubInfoQueue;
    private sInitFetchingConversations;
    private sWaitingSendHandlerSet;
    private sWaitMemberSet;
    private sGettingConversationQueue;
    isGetUserMsgIsRunning: boolean;
    constructor(context: IMSdkContext);
    onInstanceDestroy(): void;
    addWaitingAsyncRespMsg(msgUuid: string): void;
    removeWaitingAsyncRespMsg(msgUuid: string): boolean;
    addWaitConversation(inbox: number, body: im_proto.IMessageBody): void;
    /**
     * 给定的会话id，查询是否有任何加载队列正在请求会话信息
     * @param convId
     */
    isConversationFetching(convId: string): boolean;
    hasGettingConversation(conversationId: string): boolean;
    addGettingConversation(conversationId: string): void;
    addWaitMember(conversationId: string): void;
    removeWaitMember(conversationId: string): void;
    removeGettingConversation(conversationId: string): void;
    removeWaitConversation(inboxType: number, conversationId: string): void;
    hasGettingConversationSubInfo(subConversationShortId: bigint): boolean;
    addGettingConversationSubInfo(subConversationShortId: bigint): void;
    removeGettingConversationSubInfo(subConversationShortId: bigint): void;
    addInitFetchingConversations(inboxType: number, ...conversationIds: string[]): void;
    addWaitConversationSubInfo(inboxType: number, body: im_proto.IMessageBody): void;
    removeWaitConversationSubInfo(inboxType: number, subConversationShortId: bigint): void;
    /**
     * 发送消息失败的场景下，使用在线push下发的消息作为兜底
     * @param msgUuid
     * @param handler
     */
    addWaitMsgSendHandler(msgUuid: string, handler: SendMsgHandler): void;
    removeWaitMsgSendHandler(msgUuid: string): void;
    notifyWaitSendMsgHandler(message: Message): boolean;
    removeInitFetchingConversations(inboxType: number, conversationIds?: IterableIterator<string>): void;
    checkWait(params?: ConversationInfoUpdateParams): Map<string, boolean>;
}
export declare enum ConvInfoUpdateType {
    TYPE_DEFAULT = 0,
    TYPE_IM_INIT = 1,
    TYPE_GROUP_MEMBER_CHANGE = 2,
    TYPE_HAS_NEW_STRANGER = 3,
    TYPE_GROUP_SILENT = 4,
    TYPE_UPDATE_GROUP = 5
}
export interface ConversationInfoUpdateParams {
    fromInit?: Nullable<boolean>;
    updateType?: Nullable<ConvInfoUpdateType>;
    cid?: Nullable<string[]>;
}

import { Conversation } from '../../api/model/Conversation';
import { Message } from '../../api/model/Message';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export interface PullConversationParams {
    hasRepairedByV2: boolean;
    totalCount: number;
    preCheckLeakCount: number;
    minIndex: bigint;
    maxIndex: bigint;
    checkLeakStartTime: number;
    reportNewMsg: boolean;
    isDupCheck: boolean;
}
/**
 * 批量拉取会话内的消息，用于会话完整性修复后的对应会话的消息加载
 */
export declare class PullConversationMsgHandler extends IMBaseHandler {
    private reqParams;
    private currentCount;
    private newMsgCount;
    private newMsgIds;
    lastValidBody: Nullable<im_proto.MessageBody>;
    listLastMsg: Nullable<Message>;
    constructor(context: IMSdkContext, params?: Nullable<PullConversationParams>);
    get tag(): string;
    protected forceHttp(): boolean;
    pullByConversation(conversation: Nullable<Conversation>, startIndex: bigint): Promise<Nullable<im_proto.MessageBody>>;
    doPull(inbox: number, convId: string, shortId: bigint, convType: number, startIndex: bigint): Promise<Nullable<im_proto.MessageBody>>;
    /**
     * 分页加载请求拿到的response解析逻辑
     * @param item
     * @param inbox
     * @param convId
     * @param shortId
     * @param convType
     * @returns
     */
    handleResponse(item: RequestItem, inbox: number, convId: string, shortId: bigint, convType: number): Promise<boolean>;
    protected isSuccess(item: RequestItem): boolean;
}
export interface PullConversationMsgHandlerResult {
    success?: boolean;
    errorCode?: number;
    conversation?: Conversation;
    message?: Message;
}

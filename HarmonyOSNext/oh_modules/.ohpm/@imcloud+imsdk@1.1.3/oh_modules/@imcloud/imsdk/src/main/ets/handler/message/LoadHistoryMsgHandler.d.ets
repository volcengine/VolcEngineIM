import { im_proto } from '../../api/proto/index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { RequestError } from '../../api/const/error';
import { Message } from '../../api/model/Message';
import { MessageListLoadResult } from '../../observer/IMessageObserver';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { LoadHistoryMsgParams } from '../params/LoadHistoryMsgParams';
import { IMResult } from '../../api/bean/IMHandlerResult';
import { Conversation } from '../../api/model/Conversation';
/**
 * 进入消息详情页后向上👆滑动查看历史消息
 * 301接口、对应Android类LoadHistoryMsgHandler
 */
export declare class LoadHistoryMsgHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    pull(params: LoadHistoryMsgParams): Promise<IMResult<MessageListLoadResult>>;
    protected handleResponse(item: RequestItem, conversation: Conversation, params: LoadHistoryMsgParams): Promise<MessageListLoadResult>;
    protected handleError(e: RequestError): void;
    protected isSuccess(item: RequestItem): boolean;
    protected saveMessage(conversation: Conversation, recentMessages: im_proto.IMessageBody[], hasMore: boolean): Promise<[boolean, Message[]]>;
}

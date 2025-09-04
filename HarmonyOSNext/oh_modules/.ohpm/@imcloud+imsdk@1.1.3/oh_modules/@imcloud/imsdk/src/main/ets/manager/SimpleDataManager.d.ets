import { Conversation } from '../api/model/Conversation';
import { Message } from '../api/model/Message';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
/**
 * 简单在内存中存放一下拿到的conversation和message
 * 仅供测试使用
 */
export declare class SimpleDataManager extends IMSdkBaseObject {
    private readonly convMap;
    private readonly msgMap;
    constructor(context: IMSdkContext);
    insertOrUpdateConversation(conv: Conversation): void;
    insertOrUpdateMessage(msg: Message): void;
    getConversation(conversationId: string): Nullable<Conversation>;
    getConversationList(): Conversation[];
    getMessageList(conversationId: string): Message[];
}

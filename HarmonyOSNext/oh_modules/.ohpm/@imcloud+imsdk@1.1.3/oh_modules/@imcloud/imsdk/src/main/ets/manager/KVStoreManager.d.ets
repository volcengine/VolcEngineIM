import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { Conversation } from '../api/model/Conversation';
import { Message } from '../api/model/Message';
/**
 * 基于key-value数据库的数据持久化方案
 * 作为备选方案，先简单尝试
 */
export declare class KVStoreManager extends IMSdkBaseObject {
    private static ADD_ID;
    private static CONV_STORE_ID;
    private static MSG_STORE_ID;
    private kvManager?;
    private convKvStore?;
    private msgKvStore?;
    constructor(context: IMSdkContext);
    init(): Promise<void>;
    close(): Promise<void>;
    private initKVManager;
    private initKVStore;
    insertOrUpdateConversation(conv: Conversation): Promise<void>;
    insertOrUpdateMessage(msg: Message): Promise<void>;
    getConversation(conversationId: string): Promise<Nullable<Conversation>>;
    getConversationList(): Promise<Conversation[]>;
    getMessageList(conversationId: string): Promise<Message[]>;
    getAllMessageList(): Promise<Message[]>;
}

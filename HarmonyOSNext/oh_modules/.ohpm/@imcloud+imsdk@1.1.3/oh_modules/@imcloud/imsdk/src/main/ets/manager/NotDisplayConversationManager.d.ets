import { Conversation } from '../api/model/Conversation';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
/**
 * 标记会话不可见逻辑
 */
export declare class NotDisplayConversationManager extends IMSdkBaseObject {
    private notDisplayConvSet;
    constructor(context: IMSdkContext);
    /**
     * 仅更新缓存中的会话，不需要回调ConversationListModel
     * 从会话列表中移除会话
     */
    updateMemoryConversation(conversation: Nullable<Conversation>): boolean;
    getConversation(conversationId: string): Promise<Nullable<Conversation>>;
    getConversationByShortId(convShortId: bigint): Promise<Nullable<Conversation>>;
    handlerInitConversionList(convList: Conversation[]): Promise<void>;
    notDisplayConversation(conversationId: string): Promise<boolean>;
}

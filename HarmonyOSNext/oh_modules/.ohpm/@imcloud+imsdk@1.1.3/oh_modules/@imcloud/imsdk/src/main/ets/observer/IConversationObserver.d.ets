import { ConversationChangeReason } from '../api/const/consts';
import { Conversation } from '../api/model/Conversation';
import { Member } from '../api/model/Member';
export interface IConversationObserver {
    /**
     * 创建会话
     * @param conversation
     */
    onCreateConversation?: (conversation: Conversation) => void;
    /**
     * 会话列表删除回调
     * @param conversation
     */
    onDeleteConversation?: (conversation: Conversation) => void;
    /**
     * 会话列表更新回调
     * @param conversation
     * @param reason 会话更新的原因可能有多个，因此是一个list, 可以使用indexOf去检查是否存在具体的原因
     */
    onUpdateConversation?: (conversation: Conversation, reason: Nullable<ConversationChangeReason[]>) => void;
    /**
     * 会话置顶消息更新回调
     * @param conversation
     */
    onTopMessageUpdate?: (conversation: Conversation) => void;
    /**
     * 踢出群聊
     * @param conversation
     */
    onLeaveConversation?: (conversation: Conversation) => void;
    /**
     * 全量拉取群成员
     * @param conversationId
     * @param memberList
     */
    onLoadMember?: (conversationId: string, memberList: Nullable<Member[]>) => void;
    /**
     * 会话被远端销毁
     * @param conversation
     */
    onDissolveConversation?: (conversation: Conversation) => void;
    /**
     * 添加群成员
     * @param memberAdded
     */
    onAddMembers?: (memberAdded: Member[]) => void;
    /**
     * 移除群成员
     * @param memberUidRemoved 被移除群聊的群成员uid, 这样里面设计原因，可能拿不到群成员数据结构，因此这里直接设计为uidList
     */
    onRemoveMembers?: (conversationId: string, memberUidRemoved: string[]) => void;
    /**
     * 群成员刷新
     * @param updatedMembers
     */
    onUpdateMembers?: (updatedMembers: Member[]) => void;
}

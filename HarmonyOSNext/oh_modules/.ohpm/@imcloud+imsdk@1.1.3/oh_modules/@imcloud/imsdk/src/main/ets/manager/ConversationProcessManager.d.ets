import { Conversation } from '../api/model/Conversation';
import { Message } from '../api/model/Message';
import { UpdateConvResult } from '../api/bean/conversation/UpdateConvResult';
import { im_proto } from '../api/proto';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import Long from 'long';
import { SaveConvResult } from '../handler/GetUserMsgHandler';
/**
 * Conversation 会话相关的处理，对标Android的 ConversationExtUtil，及各种会话的Ext类
 */
export declare class ConversationProcessManager extends IMSdkBaseObject {
    constructor(context: IMSdkContext);
    /**
     * 仅构造会话
     * @see syncBuildLocalConversation
     * @param inboxType
     * @param conversationId
     * @param conversationShortId
     * @param conversationType
     * @param updateTime
     * @param badgeCount
     * @param lastMsg
     * @param isStranger
     * @param muteBadgeCountInfos
     * @param filterLocalExt
     * @param sortOrderMsg
     * @returns
     */
    buildLocalConversation(inboxType: number, conversationId: string, conversationShortId: bigint, conversationType: number, updateTime: number, badgeCount: number, isStranger: boolean, lastMsg?: Message, sortOrderMsg?: Message, muteBadgeCountInfos?: im_proto.IMuteBadgeCountInfo[], filterLocalExt?: Map<string, string>): Promise<Conversation>;
    /**
     * 构造会话，并写入数据库
     * @param inboxType
     * @param conversationId
     * @param conversationShortId
     * @param conversationType
     * @param updateTime
     * @param badgeCount
     * @param lastMsg
     * @param isStranger
     * @param muteBadgeCountInfos
     * @param filterLocalExt
     * @param sortOrderMsg
     */
    syncBuildLocalConversation(inboxType: number, conversationId: string, conversationShortId: bigint, conversationType: number, updateTime: number, badgeCount: number, isStranger: boolean, lastMsg?: Message, sortOrderMsg?: Message, muteBadgeCountInfos?: im_proto.IMuteBadgeCountInfo[], filterLocalExt?: Map<string, string>): Promise<Nullable<Conversation>>;
    syncUpdateConversation(conversation: Conversation, lastMsg: Message, badgeCount: number, source: number, muteBadgeCountInfos: im_proto.IMuteBadgeCountInfo[] | undefined, filterLocalExt: Map<string, string> | undefined, sortOrderMsg?: Message): Promise<UpdateConvResult>;
    getUidFromConversationId(cid: string): Promise<string>;
    msgFilter(msg: Message, filterLocalExt: Map<string, string>): Promise<void>;
    msgFilterByConversation(conversation: Conversation, msg: Message): Map<string, string>;
    /**
     * lastMessage更新，尝试更新lastHintMessage
     */
    updateLastHintMsgWithLastMsgIfNeed(conversation: Conversation): void;
    updateSkipMuteBadgeCount(muteBadgeCountInfos: im_proto.IMuteBadgeCountInfo[], conversation: Conversation): Promise<void>;
    /**
     * 存一下，当前跳过免打扰未读数，避免主线程解析耗时
     * 有数据库操作，注意在子线程调用
     */
    updateUnreadSkipMuteCount(conversation: Conversation): Promise<void>;
    /**
     * 更新会话未读重要消息数（群主发言/有人艾特我/作品更新，无视免打扰设置）
     * @param conversation
     */
    updateUnreadImportantMsgCount(conversation: Conversation): Promise<void>;
    updateLastMsgOrderIndex(listLastMsg: Message, conversationId: string, from: string): Promise<void>;
    saveSingleConversation(inboxType: number, updateTime: number, convInfo: im_proto.IConversationInfoV2, saveToDB: boolean, responseUid: Long): Promise<SaveConvResult>;
    /**
     * Conversation全缓存优化中，如果Conversation是从内存中获取的，在收到消息时，尝试更新内存中的值
     * @param conversation
     * @param lastMsg
     * @param sortOrderMsg
     */
    tryUpdateMemoryConversationUseMsg(conversation: Conversation, lastMsg: Message, sortOrderMsg?: Message): Promise<void>;
}

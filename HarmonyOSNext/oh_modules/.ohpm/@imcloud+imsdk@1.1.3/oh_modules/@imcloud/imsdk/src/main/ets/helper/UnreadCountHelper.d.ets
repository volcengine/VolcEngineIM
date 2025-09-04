import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { Conversation } from '../api/model/Conversation';
import { IConversationUnreadCountInfoObserver } from '../observer/IConversationUnreadCountInfoObserver';
export declare class UnreadCountHelper extends IMSdkBaseObject {
    /**
     * 未读数的 缓存
     */
    private unreadCountMap;
    /**
     * 未读数的 缓存 是否需要显示小黄点这种
     */
    private shouldNotifyMap;
    private unreadCountInfoObservers;
    private totalUnreadCount;
    private isUnreadCountReported;
    constructor(context: IMSdkContext);
    registerUnreadCountInfoObserver(observer: IConversationUnreadCountInfoObserver): void;
    unregisterUnreadCountInfoObserver(observer: IConversationUnreadCountInfoObserver): boolean;
    getImUnreadCountTotal(): number;
    initConversationUnreadInfo(): Promise<void>;
    private calculatorTotalUnreadCount;
    /**
     * 删
     * @param conversation
     */
    onDeleteConversation(conversation: Conversation): Promise<void>;
    /**
     * 解散
     * @param conversation
     */
    onDissolveConversation(conversation: Conversation): Promise<void>;
    /**
     * 增&改都用onUpdate接口
     * @param conversation
     */
    onUpdateConversation(conversation: Conversation): Promise<void>;
    /**
     * 退出群聊
     * @param conversation
     * @param from
     */
    onLeaveConversation(conversation: Conversation, from: string): Promise<void>;
    /**
     * 处理会话的未读数
     * @param convList
     */
    handleUnreadCount(convList: Conversation[]): Promise<void>;
    handleUnreadCountWithFilter(convList: Conversation[]): Promise<void>;
    /****
     *
     */
    private reportOnceUnreadCount;
    reportUnreadCount(needCheck: boolean): Promise<void>;
    private calculateUnreadInfo;
    private updateBizUnreadCountToDb;
    private insertOrUpdateUnreadMap;
    notifyUnreadInfoUpdate(): void;
    private isConversationUnreadValid;
    tryUpdateLabelById(conversationId: string, labelSet: Nullable<Set<string>>): void;
}
export interface UnreadCountInfo {
    unreadCount: number;
    labelSet: Nullable<Set<string>>;
}

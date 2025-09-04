import { Conversation } from '../api/model/Conversation';
import { ILabelConversationObserver } from '../observer/ILabelConversationObserver';
import { IMModel } from './IMModel';
export interface ILabelModel extends IMModel {
    addObserver(observer: ILabelConversationObserver): void;
    removeObserver(observer: ILabelConversationObserver): void;
    canUse(): boolean;
    labelHistoryConv(deep: number, from: string): void;
    /**
     * 对标Android的getTargetLabeledConvsUnreadCount方法
     * 获取特定会话标签的所有会话未读数
     * @param labelInfos
     * @param isMute
     * @returns
     */
    getTargetLabeledConversationsUnreadCount(labelInfos: string[], isMute: boolean): Promise<number>;
    /**
     * 对标Android的getTargetLabeledConvs方法
     * 获取特定会话标签的会话列表
     * @param labelInfos
     * @param isMute
     * @param maxSortOrder
     * @param minSortOrder
     * @param limit
     * @returns
     */
    getTargetLabeledConversations(labelInfos: string[], isMute: boolean, maxSortOrder: bigint, minSortOrder: bigint, limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 查询禁言的会话列表
     * @param maxSortOrder
     * @param minSortOrder
     * @param limit
     * @returns
     */
    getMuteConversations(maxSortOrder: bigint, minSortOrder: bigint, limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 对标Android的getUnreadConversationList方法
     * 获取未读的会话列表
     * @param maxSortOrder optional
     * @param limit optional
     * @returns
     */
    getUnreadConversations(maxSortOrder?: bigint, limit?: number): Promise<Nullable<Conversation[]>>;
    getNewestConversationByLabels(labels: string[], limit: number): Promise<Nullable<Conversation[]>>;
    hasLocalMuteConversations(): Promise<boolean>;
    /**
     * 触发会话标签打标，具体打标逻辑是使用业务注入的IMConversationLabelDefaultImpl#syncMultiLabel方法
     * SDK内部提供默认的打标方法是空实现！
     * IM-SDK init -> 加载最近会话链、拿到会话数据 -> SDK内部触发调用labelIncrementalConv -> 最终回调业务注入的IMConversationLabelDefaultImpl#syncMultiLabel方法
     *
     * 在初始化过程中，最近会话链
     * @param conversation
     * @param from
     */
    labelIncrementalConv(conversation: Conversation[], from: string): Promise<void>;
    /**
     * 资源回收
     */
    onInstanceDestroy(): void;
}

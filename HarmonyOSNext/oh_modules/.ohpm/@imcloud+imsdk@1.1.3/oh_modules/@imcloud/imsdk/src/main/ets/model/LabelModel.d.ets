import { Conversation } from '../api/model/Conversation';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { ILabelConversationObserver } from '../observer/ILabelConversationObserver';
import { ILabelModel } from './ILabelModel';
export declare class LabelModel extends IMSdkBaseObject implements ILabelModel {
    private labelHistoryConvFinish;
    private observerSet;
    private totalHistoryTimeCost;
    private queryUnlabeledConvNum;
    private unLabeledCount;
    private labeledCount;
    _canUse: boolean;
    constructor(context: IMSdkContext);
    addObserver(observer: ILabelConversationObserver): void;
    removeObserver(observer: ILabelConversationObserver): void;
    canUse(): boolean;
    labelHistoryConv(deep: number, from: string): Promise<void>;
    /**
     * 获取特定会话标签的所有会话未读数
     * @param labelInfos
     * @param isMute
     * @returns
     */
    getTargetLabeledConversationsUnreadCount(labelInfos: string[], isMute: boolean): Promise<number>;
    /**
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
     * 获取未读的会话列表
     * @param maxSortOrder
     * @param limit
     * @returns
     */
    getUnreadConversations(maxSortOrder?: bigint, limit?: number): Promise<Nullable<Conversation[]>>;
    /**
     * 获得符合标签要求的最新会话
     * 背景：春节活动需要查有没有 30天内有发言的 社交群 ,人数20以下
     */
    getNewestConversationByLabels(labels: string[], limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 查询是否有免打扰会话
     */
    hasLocalMuteConversations(): Promise<boolean>;
    /**
     * 处理增量数据
     * 快速在内存计算标签
     * @param conversation
     * @param from
     */
    labelIncrementalConv(convList: Conversation[], from: string): Promise<void>;
    /**
     * 在多实例场景下，不对齐Android这里的实现也ok，因为意义为空
     * 为了代码的一致性，这里也补充了相应的代码
     */
    onInstanceDestroy(): void;
}

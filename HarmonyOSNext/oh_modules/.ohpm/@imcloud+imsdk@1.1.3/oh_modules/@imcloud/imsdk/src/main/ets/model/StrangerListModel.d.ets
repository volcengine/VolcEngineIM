import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { Conversation, UpdateConversationInfo } from '../api/model/Conversation';
import { im_proto } from '../api/proto';
import { IStrangerListModel } from './IStrangerListModel';
export declare class StrangerListModel extends IMSdkBaseObject implements IStrangerListModel {
    private TAG;
    private static LOAD_FROM_SERVER_RSP;
    private isQuerying;
    private isRequesting;
    private loadMoreVersion;
    private loadMoreUpdateTime;
    private pageSize;
    private hasRefreshed;
    private hasMore;
    private strangerConvList;
    private transferringConversationSet;
    private lastStrangerBox;
    inboxType: number;
    constructor(context: IMSdkContext, inboxType?: number, pageSize?: number);
    /**
     * 资源回收
     */
    onInstanceDestroy(): void;
    /**
     * 刷新陌生人会话列表/消息盒子
     * @param bizInfo 业务透传
     * @returns undefined代表正在loading，否则为加载的结果数据
     */
    refresh(bizInfo?: string): Promise<Nullable<Conversation[]>>;
    /**
     * 触发加载更多（实质上，是加载更旧的陌生人会话）
     * @param bizInfo 业务透传
     * @param from
     * @returns undefined代表正在loading，否则为加载的结果数据
     */
    loadMore(bizInfo?: string, from?: number): Promise<Nullable<Conversation[]>>;
    /**
     * 更新内存中的陌生人会话数据，加入陌生人消息盒子
     */
    updateLoadedListToStrangerBoxMemory(strangerConvList: Conversation[]): Promise<void>;
    /**
     * 更新内存中的陌生人会话
     * @param con
     */
    updateMemoryConversation(con: Conversation): void;
    /**
     * 具体执行加载更多逻辑，私有方法
     * @param bizInfo 业务透传
     * @returns undefined代表正在loading，否则为加载的结果数据
     */
    private requestMore;
    /**
     * 刷新陌生人盒子
     */
    refreshStrangerBox(): Promise<void>;
    /**
     * 查询最近陌生人会话
     * @param minUpdateTime
     * @param limit
     * @returns
     */
    getRecentStrangerConvList(minUpdateTime: number, limit: number): Promise<Nullable<Conversation[]>>;
    /***
     * 标记全部陌生人会话已读
     */
    markAllRead(needUpdateBox?: boolean): Promise<void>;
    /**
     * 删除所有陌生人会话
     */
    deleteAllConversation(): Promise<void>;
    /**
     * 陌生人会话列表是否正在加载
     * @returns
     */
    isLoading(): boolean;
    getConversation(conversationId: string): Conversation;
    /**
     * 是否为陌生人转正
     * @param msgType
     * @returns
     */
    isStrangerTransferMsg(msgType?: Nullable<number>): boolean;
    /***
     * 陌生人转正逻辑
     */
    handleStrangerTransferByMsgBody(inboxType: number, message: Nullable<im_proto.IMessageBody>): Promise<void>;
    /***
     * 陌生人转正逻辑
     */
    handleStrangerTransfer(inboxType: number, conversationId: string, conversationShortId: bigint, conversationType: number): Promise<void>;
    /**
     * 有新的陌生人会话
     * @param conv
     */
    onGetConversation(conv: Conversation): void;
    /**
     * 删除陌生人会话
     * @param conversation
     * @param fromCmdMsg
     */
    onDeletedConversation(conversation: Conversation, fromCmdMsg?: boolean): void;
    /**
     * 更新陌生人会话
     * @param conversation
     * @param updateInfo
     */
    onUpdateConversation(conversation: Conversation, updateInfo: UpdateConversationInfo): void;
}

import { Conversation, UpdateConversationInfo } from '../api/model/Conversation';
import { im_proto } from '../api/proto';
import { IMModel } from './IMModel';
/**
 * 陌生人会话操作、陌生人消息盒子
 */
export interface IStrangerListModel extends IMModel {
    /**
     * 刷新陌生人会话列表
     * @param bizInfo 业务透传参数
     * @returns
     */
    refresh(bizInfo?: string): Promise<Nullable<Conversation[]>>;
    /**
     * 陌生人消息盒子刷新，主要是刷新陌生人Cell
     * @returns
     */
    refreshStrangerBox(): Promise<void>;
    /**
     * 触发加载更多，IM-SDK内部维护水位锚点
     * @param bizInfo
     * @param from
     * @returns
     */
    loadMore(bizInfo?: string, from?: number): Promise<Nullable<Conversation[]>>;
    /**
     * @returns 标识当前陌生人是否正在请求中
     */
    isLoading(): boolean;
    /**
     * 查询陌生人会话数据结构
     * @param convId 会话id
     * @returns 返回convId对应的陌生人会话
     */
    getConversation(convId: string): Nullable<Conversation>;
    /**
     * @param msgType 消息类型
     * @returns msgType是否为陌生人转正消息类型
     */
    isStrangerTransferMsg(msgType: Nullable<number>): boolean;
    /**
     * 触发陌生人转正为熟人朋友，IM-SDK内部调用，业务可不关注
     */
    handleStrangerTransfer(inboxType: number, conversationId: string, conversationShortId: bigint, conversationType: number): Promise<void>;
    /**
     * 触发陌生人转正为熟人朋友，IM-SDK内部调用，业务可不关注
     */
    handleStrangerTransferByMsgBody(inboxType: number, message: Nullable<im_proto.IMessageBody>): Promise<void>;
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
     * 查询最近陌生人会话
     * @param minUpdateTime
     * @param limit
     * @returns
     */
    getRecentStrangerConvList(minUpdateTime: number, limit: number): Promise<Nullable<Conversation[]>>;
    /**
     * 标记全部的陌生人会话已读
     */
    markAllRead(): Promise<void>;
    /**
     * 删除所有陌生人会话
     * @returns
     */
    deleteAllConversation(): Promise<void>;
    /**
     * 陌生人会话更新
     * @param conversation
     * @param updateInfo
     */
    onUpdateConversation(conversation: Conversation, updateInfo: UpdateConversationInfo): void;
    /**
     * 删除陌生人会话
     * @param conversation
     * @param fromCmdMsg
     */
    onDeletedConversation(conversation: Conversation, fromCmdMsg?: boolean): void;
    /**
     * 收到新的陌生人会话
     * @param conv
     */
    onGetConversation(conv: Conversation): void;
    /**
     * 资源回收
     */
    onInstanceDestroy(): void;
}

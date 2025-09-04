import { IMDataSource } from './IMDataSource';
import { Message } from '../../api/model/Message';
/**
 * 消息搜索FTS存储接口
 */
export interface IMMsgSearchDataSource extends IMDataSource {
    /**
     * 插入或更新fts索引
     * @param messageList
     * @returns
     */
    insertOrUpdateList(messageList: Message[]): Promise<void>;
    /**
     * 搜索会话内消息记录
     * @param conversationId 会话id
     * @param key 搜索内容
     * @param limit 分页拉取的limit
     * @param createdTime 查询的记录按照时间分页，这里传搜索结果列表的最后一条消息的createAt
     * @returns 返回的消息列表
     */
    queryMsgsByConvId(conversationId: string, key: string, limit: number, createdTime?: number): Promise<Nullable<Message[]>>;
    /***
     * 立刻建立搜索表索引
     */
    buildSearchIndex(): Promise<void>;
    /***
     * 延迟30s建立搜索表索引
     * @param seconds
     */
    delayBuildSearchIndex(seconds: number): void;
    deleteByCid(conversationId: string): Promise<number>;
    deleteByMsgUuid(msgUuid: string): Promise<number>;
}

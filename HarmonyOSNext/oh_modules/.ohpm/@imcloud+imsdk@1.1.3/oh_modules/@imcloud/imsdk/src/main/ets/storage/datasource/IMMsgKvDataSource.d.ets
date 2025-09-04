import { IMDataSource } from './IMDataSource';
/**
 * IMMsgKvDataSource
 * 消息key-value相关的基本存储接口
 */
export interface IMMsgKvDataSource extends IMDataSource {
    /**
     * 插入或更新消息，如果已经存在会话id、uuid对应、key对应的value则更新，否则插入
     * @param conversationId
     * @param msgUuid
     * @param key
     * @param value
     * @returns
     */
    insertOrUpdate(conversationId: string, msgUuid: string, key: string, value: string): Promise<boolean>;
    /**
     * 删除指定会话id的kv信息
     * @param convId
     * @returns
     */
    deleteByCid(convId: string): Promise<number>;
    /**
     * 根据消息uuid删除消息的kv
     * @param convId
     * @param msgUuid
     * @returns
     */
    deleteByMsgUuid(convId: string, msgUuid: string): Promise<number>;
    /**
     * 批量删除
     * @see deleteByMsgUuid
     * @param convId
     * @param msgUuid
     * @returns
     */
    deleteAllSync(convId: string, msgUuid: string[]): Promise<number>;
    /**
     * 查询指定会话、msgUuid、key对应的reference info
     * @param convId
     * @param msgUuid
     * @param key
     * @returns
     */
    get(convId: string, msgUuid: string, key: string): Promise<string | undefined>;
    getByKey(convId: string, key: string): Promise<[string, string][]>;
}

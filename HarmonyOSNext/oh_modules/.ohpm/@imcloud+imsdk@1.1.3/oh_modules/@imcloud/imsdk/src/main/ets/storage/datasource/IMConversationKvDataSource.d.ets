import { IMDataSource } from './IMDataSource';
/**
 * IMConversationKvDataSource
 * conversation key-value相关的基本存储接口
 */
export interface IMConversationKvDataSource extends IMDataSource {
    /**
     * 插入或者更新指定会话id和指定key的value内容，key为null则删除指定的conversation id的value
     * @param convId
     * @param key
     * @param value
     * @returns
     */
    insertOrUpdateKV(convId: Nullable<string>, key: Nullable<string>, value: Nullable<string>): Promise<boolean>;
    /**
     * 插入或者更新指定会话id和Map<Key,Value>的内容，@see insertOrUpdateKV
     * @param convId
     * @param key
     * @param value
     * @returns
     */
    insertOrUpdateMapKV(convId: Nullable<string>, map: Map<string, string>): Promise<number>;
    /**
     * 删除指定conversation id和指定key的value
     * @param convId
     * @param key
     * @returns
     */
    deleteKey(convId: Nullable<string>, key: Nullable<string>): Promise<boolean>;
    /**
     * 获取指定conversation id和指定key的value
     * @param convId
     * @param key
     * @returns
     */
    getValue(convId: string, key: string, useTheadPool?: boolean): Promise<string | undefined>;
    getConversationAllKV(convId: string, useThreadPool?: boolean): Promise<Map<string, string>>;
}

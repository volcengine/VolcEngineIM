import { ConversationSubInfo } from '../../api/model/ConversationSubInfo';
import { IMDataSource } from './IMDataSource';
/**
 * IMConversationCoreDataSource
 * conversation core相关的基本存储接口
 */
export interface IIMConversationSubInfoDataSource extends IMDataSource {
    /**
     * 建表命令
     * @returns
     */
    getCreator(): string;
    /**
     * 插入或更新实体
     * @param conversation
     * @returns
     */
    insertOrUpdate(conversationSubInfo: ConversationSubInfo): Promise<Nullable<boolean>>;
    /**
     * 查询数据
     * @param subConversationShortId
     * @returns 返回subConversationShortId指定的实体
     */
    get(subConversationShortId: bigint): Promise<Nullable<ConversationSubInfo>>;
    /**
     * 查询数据
     * @param subConversationShortIDList
     * @returns 返回subConversationShortIDList指定的<parentConvId, ConversationSubInfo>映射表
     */
    getSubInfoMap(subConversationShortIDList: bigint[]): Promise<Nullable<Map<string, ConversationSubInfo>>>;
    /**
     * 删除实体
     * @param conversationShortId
     * @returns undefined 标识异常情况或参数错误；true成功；false失败
     */
    delete(conversationShortId: bigint): Promise<Nullable<boolean>>;
    /**
     * 查询数据
     * @param parentConversationId
     * @returns
     */
    getConversationSubInfoByParentConversationId(parentConversationId: string): Promise<Nullable<ConversationSubInfo[]>>;
    /**
     * 删除实体
     * @param conversationId
     * @returns undefined 标识异常情况或参数错误；true成功；false失败
     */
    deleteByParentConversationId(parentConversationId: string): Promise<Nullable<boolean>>;
    /**
     * 删除所有实体
     * @returns undefined 标识异常情况或参数错误；true成功；false失败
     */
    deleteAll(): Promise<Nullable<boolean>>;
}

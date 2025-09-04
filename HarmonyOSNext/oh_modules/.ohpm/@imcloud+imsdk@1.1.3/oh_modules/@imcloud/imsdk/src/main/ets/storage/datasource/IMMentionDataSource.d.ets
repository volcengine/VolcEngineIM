import { Message } from '../../api/model/Message';
import { IMDataSource } from './IMDataSource';
/**
 * IMMentionDataSource
 * mention相关的基本存储接口
 */
export interface IMMentionDataSource extends IMDataSource {
    /**
     * 删除指定会话id的艾特（mention）信息
     * @param convId
     * @returns
     */
    deleteByCid(convId: string): Promise<number>;
    /**
     * 查询是否存在对应的消息
     * @param msgUuid
     * @returns
     */
    hasMsg(msgUuid: string): Promise<boolean>;
    /**
     * 通过消息id删除艾特（mention）信息
     * @param msgUuid
     * @returns return the number of affected rows.
     */
    deleteByMsgUuid(msgUuid: string): Promise<number>;
    /**
     * 批量删除会话消息
     * @see deleteByMsgUuid
     * @param msgUuid
     * @returns
     */
    deleteAllMessageAsync(msgUuid: string[]): Promise<number>;
    /**
     * 以会话维度批量删除
     * @param conversationIdList
     * @returns
     */
    deleteAll(conversationIdList: string[]): Promise<number>;
    /**
     * 插入或更新
     */
    upsert(msg: Message): Promise<boolean>;
    getUnreadSelfMentionedMsg(conversationId: string, readIndexV1: bigint, useTheadPool?: boolean): Promise<Message[]>;
}

import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMMentionDataSource } from '../datasource/IMMentionDataSource';
import { Message } from '../../api/model/Message';
/**
 * IMMentionDao
 */
export declare class IMMentionDao extends IMSdkBaseObject implements IMMentionDataSource {
    private readonly dbManager;
    constructor(context: IMSdkContext);
    deleteByCid(convId: string): Promise<number>;
    hasMsg(msgUuid: string): Promise<boolean>;
    deleteByMsgUuid(msgUuid: string): Promise<number>;
    deleteAllMessageAsync(msgUuid: string[]): Promise<number>;
    deleteAll(conversationIdList: string[]): Promise<number>;
    upsert(msg: Message): Promise<boolean>;
    getUnreadSelfMentionedMsg(conversationId: string, readIndexV1: bigint, useTheadPool?: boolean): Promise<Message[]>;
    private isSelfMentioned;
    private buildValues;
}

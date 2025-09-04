import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMMsgKvDataSource } from '../datasource/IMMsgKvDataSource';
/**
 * IMMsgDao
 * 消息表存储
 */
export declare class IMMsgKvDao extends IMSdkBaseObject implements IMMsgKvDataSource {
    constructor(context: IMSdkContext);
    get(convId: string, msgUuid: string, key: string): Promise<string | undefined>;
    insertOrUpdate(conversationId: string, msgUuid: string, key: string, value: string): Promise<boolean>;
    insert(conversationId: string, msgUuid: string, key: string, value: string): Promise<number>;
    update(conversationId: string, msgUuid: string, key: string, value: string): Promise<number>;
    deleteByCid(convId: string): Promise<number>;
    deleteByMsgUuid(convId: string, msgUuid: string): Promise<number>;
    deleteAllSync(convId: string, msgUuid: string[]): Promise<number>;
    /**
     *
     * @param convId
     * @param key
     * @returns [mgsUuid: valueObject][]
     */
    getByKey(convId: string, key: string): Promise<[string, string][]>;
    private hasValue;
    private buildValuesBucket;
}

import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMConversationKvDataSource } from '../datasource/IMConversationKvDataSource';
/**
 * IMConversationKvDao
 * 会话表
 */
export declare class IMConversationKvDao extends IMSdkBaseObject implements IMConversationKvDataSource {
    constructor(context: IMSdkContext);
    insertOrUpdateKV(convId: Nullable<string>, key: Nullable<string>, value: Nullable<string>): Promise<boolean>;
    insertOrUpdateMapKV(convId: string, map: Map<string, string>): Promise<number>;
    private hasKey;
    deleteKey(convId: string, key: string): Promise<boolean>;
    getValue(convId: string, key: string, useTheadPool?: boolean): Promise<string | undefined>;
    getConversationAllKV(convId: string, useTheadPool?: boolean): Promise<Map<string, string>>;
    private buildValuesBucket;
}

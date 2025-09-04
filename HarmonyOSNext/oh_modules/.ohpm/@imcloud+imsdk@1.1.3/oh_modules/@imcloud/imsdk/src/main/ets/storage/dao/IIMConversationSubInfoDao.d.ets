import { ConversationSubInfo } from '../../api/model/ConversationSubInfo';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IIMConversationSubInfoDataSource } from '../datasource/IIMConversationSubInfoDataSource';
export declare class IIMConversationSubInfoDao extends IMSdkBaseObject implements IIMConversationSubInfoDataSource {
    private readonly dbManager;
    constructor(context: IMSdkContext);
    getCreator(): string;
    insertOrUpdate(conversationSubInfo: ConversationSubInfo): Promise<Nullable<boolean>>;
    get(subConversationShortId: bigint): Promise<Nullable<ConversationSubInfo>>;
    getSubInfoMap(subConversationShortIDList: bigint[]): Promise<Nullable<Map<string, ConversationSubInfo>>>;
    delete(conversationShortId: bigint): Promise<Nullable<boolean>>;
    getConversationSubInfoByParentConversationId(parentConversationId: string): Promise<Nullable<ConversationSubInfo[]>>;
    deleteByParentConversationId(parentConversationId: string): Promise<Nullable<boolean>>;
    deleteAll(): Promise<Nullable<boolean>>;
}

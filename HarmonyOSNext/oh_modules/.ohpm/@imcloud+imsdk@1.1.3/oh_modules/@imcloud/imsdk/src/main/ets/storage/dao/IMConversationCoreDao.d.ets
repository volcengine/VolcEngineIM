import { ConversationCoreInfo } from '../../api/model/ConversationCoreInfo';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMConversationCoreDataSource } from '../datasource/IMConversationCoreDataSource';
/**
 * IMConversationCoreDao
 * 会话表
 */
export declare class IMConversationCoreDao extends IMSdkBaseObject implements IMConversationCoreDataSource {
    private readonly dbManager;
    constructor(context: IMSdkContext);
    hasConversationCoreInfo(conversationId: string): Promise<boolean>;
    /**
     * 根据会话id查询会话的coreInfo
     * @param conversationId
     * @returns
     */
    getConversationCoreInfo(conversationId: string, useTheadPool?: boolean): Promise<ConversationCoreInfo | undefined>;
    /**
     * @param corInfo
     * @returns
     */
    insertOrUpdate(convInfo: ConversationCoreInfo): Promise<boolean>;
    delete(convId: string): Promise<number>;
}

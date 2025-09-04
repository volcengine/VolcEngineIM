import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMConversationSettingDataSource } from '../datasource/IMConversationSettingDataSource';
import { ConversationSettingInfo } from '../../api/model/ConversationSettingInfo';
/**
 * IMConversationDao
 * 会话表
 */
export declare class IMConversationSettingDao extends IMSdkBaseObject implements IMConversationSettingDataSource {
    private readonly dbManager;
    constructor(context: IMSdkContext);
    getConversationSettingInfo(conversationId: string, useTheadPool?: boolean): Promise<ConversationSettingInfo | undefined>;
    insertOrUpdate(convSettingInfo: ConversationSettingInfo): Promise<boolean>;
    delete(convId: string): Promise<number>;
    private insert;
    private update;
    private hasExist;
    /**
     * 查询是否有免打扰会话
     * @returns
     */
    hasLocalMuteConversations(): Promise<boolean>;
}

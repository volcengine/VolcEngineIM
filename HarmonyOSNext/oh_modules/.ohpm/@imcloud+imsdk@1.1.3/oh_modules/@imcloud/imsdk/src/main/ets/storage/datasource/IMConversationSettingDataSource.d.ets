import { ConversationSettingInfo } from '../../api/model/ConversationSettingInfo';
import { IMDataSource } from './IMDataSource';
/**
 * IMConversationSettingDataSource
 * conversation setting相关的基本存储接口
 */
export interface IMConversationSettingDataSource extends IMDataSource {
    /**
     * 如果已经存在，则更新，不存在则插入
     * @param conversation
     * @returns true 成功；false失败
     */
    insertOrUpdate(conversation: ConversationSettingInfo): Promise<boolean>;
    /**
     * 根据会话id查询conversation settings info
     * @param conversationId
     * @returns
     */
    getConversationSettingInfo(conversationId: string, useTheadPool?: boolean): Promise<ConversationSettingInfo | undefined>;
    /**
     * 查询是否有免打扰会话
     * @returns
     */
    hasLocalMuteConversations(): Promise<boolean>;
    /**
     * 删除指定会话id的setting info
     * @param convId
     * @returns
     */
    delete(convId: string): Promise<number>;
}

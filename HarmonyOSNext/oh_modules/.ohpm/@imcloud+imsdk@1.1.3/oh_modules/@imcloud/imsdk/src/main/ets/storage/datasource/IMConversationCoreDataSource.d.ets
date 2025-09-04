import { ConversationCoreInfo } from '../../api/model/ConversationCoreInfo';
import { IMDataSource } from './IMDataSource';
/**
 * IMConversationCoreDataSource
 * conversation core相关的基本存储接口
 */
export interface IMConversationCoreDataSource extends IMDataSource {
    insertOrUpdate(conversation: ConversationCoreInfo): Promise<boolean>;
    getConversationCoreInfo(conversationId: string, useTheadPoo?: boolean): Promise<ConversationCoreInfo | undefined>;
    delete(convId: string): Promise<number>;
}

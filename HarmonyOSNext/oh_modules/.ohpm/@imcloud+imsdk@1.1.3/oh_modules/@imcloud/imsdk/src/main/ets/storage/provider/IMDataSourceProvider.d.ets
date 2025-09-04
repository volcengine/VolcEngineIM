import { IIMConversationSubInfoDataSource } from '../datasource/IIMConversationSubInfoDataSource';
import { IMAttachmentDataSource } from '../datasource/IMAttachmentDataSource';
import { IMConversationCoreDataSource } from '../datasource/IMConversationCoreDataSource';
import { IMConversationDataSource } from '../datasource/IMConversationDataSource';
import { IMConversationKvDataSource } from '../datasource/IMConversationKvDataSource';
import { IMConversationMemberDataSource } from '../datasource/IMConversationMemberDataSource';
import { IMConversationSettingDataSource } from '../datasource/IMConversationSettingDataSource';
import { IMMentionDataSource } from '../datasource/IMMentionDataSource';
import { IMMsgDataSource } from '../datasource/IMMsgDataSource';
import { IMMsgSearchDataSource } from '../datasource/IMMsgSearchDataSource';
import { IMMsgKvDataSource } from '../datasource/IMMsgKvDataSource';
import { IMMsgPropertyDataSource } from '../datasource/IMMsgPropertyDataSource';
import { IMConversationMemberReadDataSource } from '../datasource/IMConversationMemberReadDataSource';
/**
 * IMDataSourceProvider
 */
export interface IMDataSourceProvider {
    provideMsgDataSource(): IMMsgDataSource;
    provideMsgKvDataSource(): IMMsgKvDataSource;
    provideMsgPropertyDataSource(): IMMsgPropertyDataSource;
    provideMentionDataSource(): IMMentionDataSource;
    provideAttachmentDataSource(): IMAttachmentDataSource;
    provideConversationCoreDataSource(): IMConversationCoreDataSource;
    provideConversationDataSource(): IMConversationDataSource;
    provideConversationKvDataSource(): IMConversationKvDataSource;
    provideConversationMemberDataSource(): IMConversationMemberDataSource;
    provideConversationMemberReadDataSource(): IMConversationMemberReadDataSource;
    provideConversationSettingDataSource(): IMConversationSettingDataSource;
    provideMsgSearchDataSource(): IMMsgSearchDataSource;
    provideConversationSubInfoDataSource(): IIMConversationSubInfoDataSource;
}

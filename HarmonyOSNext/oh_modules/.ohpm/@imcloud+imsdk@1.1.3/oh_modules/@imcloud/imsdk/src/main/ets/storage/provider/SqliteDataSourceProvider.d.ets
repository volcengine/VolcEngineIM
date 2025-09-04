import { IMDataSourceProvider } from './IMDataSourceProvider';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMAttachmentDataSource } from '../datasource/IMAttachmentDataSource';
import { IMConversationCoreDataSource } from '../datasource/IMConversationCoreDataSource';
import { IMConversationDataSource } from '../datasource/IMConversationDataSource';
import { IMConversationKvDataSource } from '../datasource/IMConversationKvDataSource';
import { IMConversationMemberDataSource } from '../datasource/IMConversationMemberDataSource';
import { IMConversationSettingDataSource } from '../datasource/IMConversationSettingDataSource';
import { IMMentionDataSource } from '../datasource/IMMentionDataSource';
import { IMMsgDataSource } from '../datasource/IMMsgDataSource';
import { IMMsgKvDataSource } from '../datasource/IMMsgKvDataSource';
import { IMMsgPropertyDataSource } from '../datasource/IMMsgPropertyDataSource';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMMsgSearchDataSource } from '../datasource/IMMsgSearchDataSource';
import { IIMConversationSubInfoDataSource } from '../datasource/IIMConversationSubInfoDataSource';
import { IMConversationMemberReadDataSource } from '../datasource/IMConversationMemberReadDataSource';
/**
 * SqliteDataSourceProvider
 * 基于Sqlite数据库的实现
 */
export declare class SqliteDataSourceProvider extends IMSdkBaseObject implements IMDataSourceProvider {
    constructor(context: IMSdkContext);
    provideMsgDataSource(): IMMsgDataSource;
    provideMsgKvDataSource(): IMMsgKvDataSource;
    provideMsgPropertyDataSource(): IMMsgPropertyDataSource;
    provideMentionDataSource(): IMMentionDataSource;
    provideAttachmentDataSource(): IMAttachmentDataSource;
    provideConversationCoreDataSource(): IMConversationCoreDataSource;
    provideConversationDataSource(): IMConversationDataSource;
    provideConversationKvDataSource(): IMConversationKvDataSource;
    provideConversationMemberDataSource(): IMConversationMemberDataSource;
    provideConversationSettingDataSource(): IMConversationSettingDataSource;
    provideMsgSearchDataSource(): IMMsgSearchDataSource;
    provideConversationSubInfoDataSource(): IIMConversationSubInfoDataSource;
    provideConversationMemberReadDataSource(): IMConversationMemberReadDataSource;
}

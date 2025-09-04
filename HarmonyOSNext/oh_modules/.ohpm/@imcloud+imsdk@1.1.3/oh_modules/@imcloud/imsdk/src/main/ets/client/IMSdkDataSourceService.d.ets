import { IIMConversationSubInfoDataSource } from '../storage/datasource/IIMConversationSubInfoDataSource';
import { IMAttachmentDataSource } from '../storage/datasource/IMAttachmentDataSource';
import { IMConversationCoreDataSource } from '../storage/datasource/IMConversationCoreDataSource';
import { IMConversationDataSource } from '../storage/datasource/IMConversationDataSource';
import { IMConversationKvDataSource } from '../storage/datasource/IMConversationKvDataSource';
import { IMConversationMemberDataSource } from '../storage/datasource/IMConversationMemberDataSource';
import { IMConversationSettingDataSource } from '../storage/datasource/IMConversationSettingDataSource';
import { IMMentionDataSource } from '../storage/datasource/IMMentionDataSource';
import { IMMsgDataSource } from '../storage/datasource/IMMsgDataSource';
import { IMMsgSearchDataSource } from '../storage/datasource/IMMsgSearchDataSource';
import { IMMsgKvDataSource } from '../storage/datasource/IMMsgKvDataSource';
import { IMMsgPropertyDataSource } from '../storage/datasource/IMMsgPropertyDataSource';
import { IMSdkContext } from './IMSdkContext';
import { IMConversationMemberReadDataSource } from '../storage/datasource/IMConversationMemberReadDataSource';
/**
 * 数据存储类型datasource的管理service
 */
export declare class IMSdkDataSourceService {
    protected readonly context: IMSdkContext;
    private readonly dataSourceProvider;
    private _msgDataSource?;
    private _msgKvDataSource?;
    private _msgPropertyDataSource?;
    private _conversationDataSource?;
    private _conversationCoreDataSource?;
    private _conversationKvDataSource?;
    private _conversationMemberDataSource?;
    private _conversationMemberReadDataSource?;
    private _conversationSettingDataSource?;
    private _attachmentDataSource?;
    private _mentionDataSource?;
    private _msgSearchDataSource?;
    private _conversationSubInfoDataSource?;
    constructor(context: IMSdkContext);
    get msgDataSource(): IMMsgDataSource;
    get msgKvDataSource(): IMMsgKvDataSource;
    get msgPropertyDataSource(): IMMsgPropertyDataSource;
    get conversationDataSource(): IMConversationDataSource;
    get conversationCoreDataSource(): IMConversationCoreDataSource;
    get conversationKvDataSource(): IMConversationKvDataSource;
    get conversationMemberDataSource(): IMConversationMemberDataSource;
    get conversationMemberReadDataSource(): IMConversationMemberReadDataSource;
    get conversationSettingDataSource(): IMConversationSettingDataSource;
    get attachmentDataSource(): IMAttachmentDataSource;
    get mentionDataSource(): IMMentionDataSource;
    get msgSearchDataSource(): IMMsgSearchDataSource;
    get conversationSubInfoDataSource(): IIMConversationSubInfoDataSource;
}

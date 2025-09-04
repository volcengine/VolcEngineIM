import { IIMSdkClient, IMSdkCreateBeanService } from './IMSdkClient';
import { IMOption } from '../api/IMOptions';
import { Context } from '@ohos.abilityAccessCtrl';
import { IMSdkManagerService } from './IMSdkManagerService';
import { IMSdkModelService } from './IMSdkModelService';
import { IMSdkHandlerService } from './IMSdkHandlerService';
import { GetUserMsgParams } from '../handler/params/GetUserMsgParams';
import { IMSdkDataSourceService } from './IMSdkDataSourceService';
import { IIMSdkDepend } from '../api/depend/IMSdkDepends';
import { LeakMsgRepairedRangeStore } from '../model/LeakMsgRepairedRangeStore';
import { CheckRangeListStore } from '../model/CheckRangeListStore';
import { UnreadCountHelper } from '../helper/UnreadCountHelper';
import { WaitChecker } from '../helper/WaitChecker';
import { ObserverManager } from '../observer/ObserverManager';
import { IIMLogDepend } from '../api/depend/IIMLogDepend';
import { SendMsgCache } from '../helper/SendMsgCache';
import { IMUtilService } from './IMUtilService';
import { RecentLinkRangeManager } from '../manager/RecentLinkRangeManager';
import { LeakMsgRepairModel } from '../model/LeakMsgRepairModel';
import { CommandVersionRangeManager } from '../manager/CommandVersionRangeManager';
import { TempVersionRangeManager } from '../manager/TempVersionRangeManager';
import { BatchGetMultiConversationParticipantsReadIndexHelper } from '../handler/conversation/batch/BatchGetMultiConversationParticipantsReadIndexHelper';
import { NotDisplayConversationManager } from '../manager/NotDisplayConversationManager';
import { IMNtpTimeUtils } from './IMNtpTimeUtils';
/**
 * IMSdkClient里对IMSDK内部使用的接口，如获取配置信息之类
 */
interface IIMSdkContext {
}
/**
 * IMSDK内部统一实体
 */
export declare class IMSdkContext implements IIMSdkContext, IIMSdkClient {
    readonly option: IMOption;
    readonly depend: IIMSdkDepend;
    readonly context: Context;
    private readonly clientInit;
    private readonly managerService;
    private readonly handlerService;
    private readonly dataSourceService;
    private readonly modelService;
    private readonly createBeanService;
    readonly logger: IIMLogDepend;
    readonly leakMsgRepairRangeStore: LeakMsgRepairedRangeStore;
    readonly recentLinkRangeManager: RecentLinkRangeManager;
    readonly commandVersionRangeManager: CommandVersionRangeManager;
    readonly tempVersionRangeManager: TempVersionRangeManager;
    readonly notDisplayManager: NotDisplayConversationManager;
    readonly leakMsgRepairModel: LeakMsgRepairModel;
    readonly checkRangeListStore: CheckRangeListStore;
    readonly unreadCountHelper: UnreadCountHelper;
    readonly convParticipantsReadIndexHelper: BatchGetMultiConversationParticipantsReadIndexHelper;
    readonly waitChecker: WaitChecker;
    readonly sendMsgCache: SendMsgCache;
    readonly utilService: IMUtilService;
    readonly ntpUtils: IMNtpTimeUtils;
    constructor(context: Context, option: IMOption, depend: IIMSdkDepend);
    getCreateBeanService(): IMSdkCreateBeanService;
    init(from: string): Promise<void>;
    preInit(from: string): void;
    login(): Promise<void>;
    logout(): void;
    release(): void;
    refreshToken(): void;
    syncMsgByUser(param: GetUserMsgParams): void;
    getModelService(): IMSdkModelService;
    getManagerService(): IMSdkManagerService;
    getHandlerService(): IMSdkHandlerService;
    getDataSourceService(): IMSdkDataSourceService;
    getObserverManager(): ObserverManager;
}
export {};

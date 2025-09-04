import { IMOption } from '../api/IMOptions';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkDataSourceService } from '../client/IMSdkDataSourceService';
import { IMSdkManagerService } from '../client/IMSdkManagerService';
import { IMSdkModelService } from '../client/IMSdkModelService';
import { CommonHelper } from '../helper/CommonHelper';
import { CommandMessageManager } from '../manager/CommandMessageManager';
import { IMessageOperator } from '../model/operator/IMessageOperator';
import { SeqIdManager } from '../request/RequestItem';
import { RequestManager } from '../request/RequestManager';
import { InboxTypeService } from '../service/InboxTypeService';
import { PreferencesService } from '../service/PreferencesService';
/**
 * IIMSdkBase
 */
export interface IIMSdkBase {
    getContext(): IMSdkContext;
}
/**
 * IMSdkBaseObject：IMSDK中的实现类需要使用到IMSdkContext能力的都需要继承这个类
 */
export declare class IMSdkBaseObject implements IIMSdkBase {
    protected readonly context: IMSdkContext;
    constructor(context: IMSdkContext);
    getContext(): IMSdkContext;
    protected get option(): IMOption;
    protected get dataSourceService(): IMSdkDataSourceService;
    protected get managerService(): IMSdkManagerService;
    protected get modelService(): IMSdkModelService;
    protected get requestManager(): RequestManager;
    protected get seqIdManager(): SeqIdManager;
    protected get inboxTypeService(): InboxTypeService;
    protected get preferencesService(): PreferencesService;
    protected get messageService(): IMessageOperator;
    protected get commandMessageManager(): CommandMessageManager;
    protected get commonHelper(): CommonHelper;
    logD(...args: string[]): void;
    logI(...args: string[]): void;
    logW(...args: string[]): void;
    logE(...args: string[]): void;
}

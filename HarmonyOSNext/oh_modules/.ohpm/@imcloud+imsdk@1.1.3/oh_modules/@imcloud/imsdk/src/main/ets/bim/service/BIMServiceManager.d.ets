import { IMAccessor } from '@imcloud/imsdk_common/src/main/ets/api/IMAccessor';
import { IMEnvService, IMLogService, IMNetService, IMUploaderService, IMWSService } from '@imcloud/imsdk_common';
import { BIMConversationService } from './BIMConversationService';
import { IMSdkClient } from '../../client/IMSdkClient';
import { BIMMessageService } from './BIMMessageService';
import { BIMClient } from '../api/BIMClient';
import { BIMINService } from './BIMINService';
import { BIMCoreInitService } from './BIMCoreInitService';
import { BIMLiveExpandService } from '../../live/api/interface/BIMLiveExpandService';
export declare class BIMServiceManager {
    private _innerClient;
    get innerClient(): IMSdkClient | undefined;
    private _logService;
    isLogRegister: boolean;
    get logService(): IMLogService;
    private _netService;
    isNetRegister: boolean;
    get netService(): IMNetService;
    private _wsService;
    private isWSRegister;
    get wsService(): IMWSService;
    private _envService;
    isEnvRegister: boolean;
    get envService(): IMEnvService;
    private _conversationService;
    private _messageService;
    private _inService;
    private _liveService;
    get liveService(): BIMLiveExpandService | undefined;
    get inService(): BIMINService | undefined;
    private _uploadService;
    get uploadService(): IMUploaderService;
    get messageService(): BIMMessageService | undefined;
    get conversationService(): BIMConversationService | undefined;
    private _coreInitService;
    get coreInitService(): BIMCoreInitService;
    /**
     * 提供工具方法便于访问IM-SDK内部与本地数据处理相关的model
     * @returns
     */
    getIMModelService(): import("../../client/IMSdkModelService").IMSdkModelService;
    private _serviceList;
    private _expandList;
    private _context;
    private _imAccessor;
    constructor(context: Context, imAccessor: IMAccessor);
    init(context: Context, imAccessor: IMAccessor): Promise<void>;
    registerBusinessService(innerClient: IMSdkClient, bimClient: BIMClient): void;
    logout(): void;
    login(context: Context, uid: bigint): void;
    onConfigReady(json: string): void;
    logError(content: string): void;
    logInfo(content: string): void;
    registerNetService(netService: IMNetService): void;
    registerLogService(logService: IMLogService): void;
    registerEnvService(envService: IMEnvService): void;
    registerWSService(wsService: IMWSService): void;
    getWSService(): IMWSService;
}

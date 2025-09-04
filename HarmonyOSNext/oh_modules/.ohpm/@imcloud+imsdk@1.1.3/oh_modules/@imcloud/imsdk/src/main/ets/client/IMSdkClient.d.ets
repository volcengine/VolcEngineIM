/**
 * IMSdkClient对外暴露的接口定义
 * 所有使用SDK内部能力，只能通过接口访问，不要直接使用SDK内部类来访问能力
 */
import { Context } from '@ohos.abilityAccessCtrl';
import { GetUserMsgParams } from '../handler/params/GetUserMsgParams';
import { IMOption } from '../api/IMOptions';
import { IIMSdkDepend } from '../api/depend/IMSdkDepends';
import { IMSdkContext } from './IMSdkContext';
import { IMSdkHandlerService } from './IMSdkHandlerService';
import { IMSdkModelService } from './IMSdkModelService';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { MessageBuilder } from '../api/model/Message';
import { IMUtilService } from './IMUtilService';
/**
 * 对外暴露的接口
 */
export interface IIMSdkClient {
    /**
     * init
     * 一些初始化的工作
     */
    init(from: string): Promise<void>;
    /**
     * preInit
     * 先留着，后面看下还需不需要这个api
     */
    preInit(from: string): void;
    /**
     * login
     */
    login(): Promise<void>;
    /**
     * logout
     */
    logout(): void;
    /**
     * release
     */
    release(): void;
    /**
     * syncMsgByUser
     * 上层触发syncMsgByUser刷新
     */
    syncMsgByUser(param: GetUserMsgParams): void;
    /**
     * refreshToken
     */
    refreshToken(): void;
    /**
     * IIMSdkModelService,获取所有model
     * @returns
     */
    getModelService(): IMSdkModelService;
    /**
     *
     * @returns
     */
    getHandlerService(): IMSdkHandlerService;
    /**
     * 提供创建数据Bean的服务
     */
    getCreateBeanService(): IMSdkCreateBeanService;
}
/**
 * IMSDK对外暴露的统一入口
 */
export declare class IMSdkClient implements IIMSdkClient {
    private readonly context;
    constructor(context: Context, option: IMOption, depend: IIMSdkDepend);
    /**
     * test for inner use
     * @returns
     */
    getContext(): IMSdkContext;
    init(from: string): Promise<void>;
    preInit(from: string): void;
    login(): Promise<void>;
    logout(): void;
    release(): void;
    refreshToken(): void;
    syncMsgByUser(param: GetUserMsgParams): void;
    getModelService(): IMSdkModelService;
    getHandlerService(): IMSdkHandlerService;
    getUtilService(): IMUtilService;
    getCreateBeanService(): IMSdkCreateBeanService;
}
export declare class IMSdkCreateBeanService extends IMSdkBaseObject {
    constructor(imSdkContext: IMSdkContext);
    createMessageBuilder(): MessageBuilder;
}

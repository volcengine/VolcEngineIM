import { IMSdkContext } from '../client/IMSdkContext';
import { GetUserMsgParams } from '../handler/params/GetUserMsgParams';
import { IMSdkBaseObject } from './IMSdkBaseObject';
/**
 * IMClient初始化管理类，对应Android IMClient
 */
export declare class IMClientManager extends IMSdkBaseObject {
    private isLogin;
    private isPagination;
    loginTime: number;
    private initHandlerList;
    constructor(context: IMSdkContext);
    init(from: string): void;
    preInit(from: string): void;
    /**
     * 触发IM登录，会开始建立IM通道，成功后会开始接受离线消息。若从未登录，会先进行会话初始化。
     * 登录登出，确保成对调用
     */
    login(): Promise<void>;
    /**
     * 触发IM登出
     * 登录登出，确保成对调用
     */
    logout(): void;
    syncMsgByUser(param: GetUserMsgParams): void;
    refreshToken(): void;
    private updatePaginationFlag;
    private initIM;
}

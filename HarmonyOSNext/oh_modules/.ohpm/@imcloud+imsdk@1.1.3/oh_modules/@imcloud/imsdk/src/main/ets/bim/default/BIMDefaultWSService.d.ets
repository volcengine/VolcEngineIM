import { IMAccessor, IMEnvService, IMLogService, IMWSConnectListener, IMWSMsgInfo, IMWSService, WSParameter } from '@imcloud/imsdk_common';
export declare class BIMDefaultWSService implements IMWSService {
    onAppForegroundChang(isForeground: boolean): void;
    initWs(env: IMEnvService, logger: IMLogService): void;
    connect(wsParameter: WSParameter): Promise<boolean>;
    setConnectChangedListener(statusListener: IMWSConnectListener): void;
    setOnReceiveListener(listener: (data: IMWSMsgInfo) => void): void;
    isConnect(): boolean;
    geConnectStatus(): number;
    sendMsg(data: IMWSMsgInfo): void;
    disConnect(): Promise<boolean>;
    onConfigReady(json: string): void;
    init(context: Context, imAccessor: IMAccessor): void;
    unInit(context: Context): void;
    onLogin(context: Context, uid: bigint): void;
    onLogout(): void;
}

import { IMAccessor, IMEnvService, WSParameter } from '@imcloud/imsdk_common';
/**
 * 兜底使用，无实际意义
 */
export declare class BIMDefaultEnvService implements IMEnvService {
    initEnv(env: number, lane: string, appID: number): void;
    getEnv(): number;
    getHost(): string;
    getHeaderMap(): Map<string, string>;
    getWSParameter(): WSParameter;
    getWSHost(): string;
    onConfigReady(json: string): void;
    init(context: Context, imAccessor: IMAccessor): void;
    unInit(context: Context): void;
    onLogin(context: Context, uid: bigint): void;
    onLogout(): void;
}

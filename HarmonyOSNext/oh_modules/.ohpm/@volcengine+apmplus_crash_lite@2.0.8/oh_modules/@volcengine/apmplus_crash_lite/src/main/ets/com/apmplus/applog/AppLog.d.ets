import { INetworkClient } from '../../bytedance/hpem/net/INetworkClient';
import { InitConfig } from './InitConfig';
export declare class AppLog {
    private static instances;
    private config;
    private context;
    private networkClient;
    private constructor();
    static init(h: Context, i: InitConfig, j: INetworkClient): AppLog;
    static getInstance(g: string): AppLog;
    setNetworkNetClient(f: INetworkClient): void;
    onLaunchEvent(): void;
    getNetworkClient(): INetworkClient;
    getContent(): import("@volcengine/apmplus_crash_lite/../../../../../../../Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/ets/api/application/Context").default;
    getConfig(): InitConfig;
    savedDeviceId: string | undefined;
    getDeviceId(): string;
    static getSavedDeviceId(a: Context, b: string): string;
}

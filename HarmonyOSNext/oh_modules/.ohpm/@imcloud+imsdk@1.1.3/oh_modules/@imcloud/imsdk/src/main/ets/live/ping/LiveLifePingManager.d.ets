import Long from 'long';
import { BIMConnectStatus, BIMMessage } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
/**
 * 直播间心跳
 */
export declare class LiveLifePingManager {
    private TAG;
    private static CONFIG_INTERVAL;
    private static FREQUENT_INTERVAL;
    private interval;
    private conversationShortId;
    private status;
    private listener;
    private imsdkContext;
    private bimClient;
    private isStop;
    constructor(sdkContext: IMSdkContext, conversationId: string, listener: OnPingStatusChangedListener);
    log(content: string): void;
    private loop;
    startPing(): void;
    stopPing(): void;
    realPing(): Promise<void>;
    statusChanged(s: PingStatus): void;
    statusChangedInfo(status: PingStatus, message: BIMMessage | undefined, onLineCount: Long): void;
    getPinStatus(): PingStatus;
    static setInterval(interval: number): void;
    static setShortInterval(interval: number): void;
    onConnectStatusChanged(connectStatus: BIMConnectStatus): void;
}
export interface OnPingStatusChangedListener {
    onPingStatusChanged(pingInfo: PingInfo): void;
}
export declare enum PingStatus {
    IDLE = 0,
    PING_START = 1,
    PING_ING = 2,
    PING_SUCCESS = 3,
    PING_FAILED = 4,
    PING_STOP = 5
}
export declare class PingInfo {
    pingStatus: PingStatus;
    serverLastMessage: BIMMessage | undefined;
    onLineCount: Long;
    constructor(pingStatus: PingStatus, serverLastMessage: BIMMessage | undefined, onlineCount: Long);
}

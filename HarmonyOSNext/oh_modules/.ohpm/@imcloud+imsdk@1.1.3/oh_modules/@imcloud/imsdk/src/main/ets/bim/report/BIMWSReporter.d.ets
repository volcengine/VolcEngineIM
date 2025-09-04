import { BIMConnectStatus } from '../api/enum/BIMConnectStatus';
import { BIMReporterManager } from './BIMReporterManager';
/**
 * 长连接相关上报
 */
export declare class BIMWSReporter {
    private readonly TAG;
    private imAccessor;
    private logger;
    private connectingTime;
    private retryCount;
    private lastStatus;
    private reportManager;
    private interval;
    constructor(reportManager: BIMReporterManager);
    connectStatusChanged(status: BIMConnectStatus, log: string): void;
    /**
     * 上报长连接建连监控,0:成功 1:失败
     */
    private reportConnect;
    private loopCheckConnect;
    /**
     * 长连接在线率
     */
    private reportWsState;
}
export declare class WSError {
}

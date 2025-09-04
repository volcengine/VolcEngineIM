import { RequestItem } from '../../request/RequestItem';
import { BIMReporterManager } from './BIMReporterManager';
export declare class BIMNetReporter {
    private reportManager;
    constructor(reportManager: BIMReporterManager);
    creteNetReportTrace(): NetReportTrace;
}
export declare class NetReportTrace {
    private reportManager;
    private record;
    constructor(reportManager: BIMReporterManager);
    initByItem(item: RequestItem): void;
    setResult(isSuccess: boolean): void;
    setPath(path: string): void;
    setCmd(cmd: number): void;
    seqId(seqId: number): void;
    duration(duration: number): void;
    netType(isWs: boolean): void;
    retryTimes(retryTimes: number): void;
    logId(logId: string): void;
    status(status: number): void;
    errorCode(errorCode: number): void;
    errorMsg(errorMsg: string): void;
    /**
     * 服务端有返回
     * @param item
     */
    updateByItem(item: RequestItem): void;
    /**
     * 无返回已经抛异常
     * @param e
     */
    updateByException(item: RequestItem, e: object): void;
    report(): void;
}

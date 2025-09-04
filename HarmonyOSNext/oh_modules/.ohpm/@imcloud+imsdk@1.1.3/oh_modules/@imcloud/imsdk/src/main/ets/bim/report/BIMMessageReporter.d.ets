import { BIMReporterManager } from './BIMReporterManager';
/**
 * 消息相关上报
 */
export declare class BIMMessageReporter {
    private reportManager;
    constructor(manager: BIMReporterManager);
    createSendTrace(): SendTrace;
    createReceiveTrace(): ReceiveTrace;
    createMsgCheckTrace(): CheckMsgTrace;
}
export declare class SendTrace {
    private record;
    private imAccessor;
    private logger;
    private reportManager;
    constructor(reportManager: BIMReporterManager);
    setConvType(type: number): void;
    setConvId(cid: string): void;
    errorCode(errorCode: number): void;
    errormsg(errorMsg: number): void;
    checkCode(code: number): void;
    checkStatus(status: number): void;
    fromPush(isPush: boolean): void;
    isWS(isWs: boolean): void;
    logId(logId: string): void;
    msgType(msgType: number): void;
    msgUUID(uuid: string): void;
    pushBeforRsp(isPushBefore: boolean): void;
    result(isSuccess: boolean): void;
    sdkStart(): void;
    sdkEnd(): void;
    sendStart(): void;
    sendEnd(): void;
    report(): void;
}
export declare class ReceiveTrace {
    private imAccessor;
    private logger;
    private record;
    private reportManager;
    constructor(reportManager: BIMReporterManager);
    setConvType(type: number): void;
    setConvId(cid: string): void;
    logId(logId: string): void;
    msgType(msgType: number): void;
    msgUUID(uuid: string): void;
    result(isSuccess: boolean): void;
    receiveStarTime(receiveStartTime: number): void;
    receiveEndTime(receiveEndTime: number): void;
    sendStartTime(sendStartTime: number): void;
    setSTime(sendMsgTime: number): void;
    receiveMsgTime(receiveMsgTime: number): void;
    setSEndTime(endTime: number): void;
    isWS(isWS: boolean): void;
    sendOS(sendOS: string): void;
    report(): void;
}
export declare class CheckMsgTrace {
    private reportManager;
    private record;
    constructor(reportManager: BIMReporterManager);
    setCid(cid: string): void;
    setConvType(type: number): void;
    setLeakIds(leakIds: string): void;
    preCheckLeakCount(preLeakCount: number): void;
    setLeakCount(leakCount: number): void;
    setDuration(duration: number): void;
    setLinkMode(): void;
    setDup(isDup: boolean): void;
    setRepairedV2(hasRepairedV2: boolean): void;
    report(): void;
}

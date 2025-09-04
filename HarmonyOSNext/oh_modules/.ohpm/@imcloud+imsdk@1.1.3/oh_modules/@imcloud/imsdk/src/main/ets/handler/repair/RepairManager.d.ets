import { BIMClient } from '../../bim/api/BIMClient';
export declare class RepairManager {
    private TAG;
    private bimClient;
    private interval;
    private isEnable;
    private logger;
    private tag;
    private isWsDisconnectAutoPull;
    private running;
    constructor(bimClient: BIMClient);
    private initInterval;
    /**
     * 动态更新interval,服务端返回
     * @param nextInterval
     */
    updateInterval(nextInterval: number): void;
    getInterval(): number;
    private isInitDone;
    triggerLoopMsgByMsgEnd(): void;
    triggerLoopMsgByWS(): void;
    start(): void;
    stop(): void;
    private loop;
}

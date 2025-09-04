/**
 * 性能统计
 */
export declare class InitPerformRecorder {
    private TAG;
    private startTime;
    private lastReqStartTime;
    private serverTotalCost;
    private lastDoInitStartTime;
    private doInitTotalCost;
    private pageCount;
    private lastLoopTime;
    private delaySum;
    private delayMax;
    private loopCount;
    private looper;
    start(): void;
    reqServerStart(): void;
    reqServerEnd(seqId: number): void;
    startDoInit(seqId: number): void;
    endDoInit(seqId: number): void;
    end(convCount: number, msgCount: number): void;
}

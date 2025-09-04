import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export interface ITask {
    run(): Promise<void>;
}
export declare class IntervalTask {
    task: ITask;
    taskState: number;
    constructor(task: ITask);
    isStarted(): boolean;
    start(): Promise<void>;
}
export declare class IntervalRequest extends IMSdkBaseObject {
    private running;
    private taskList;
    private intervalTime;
    private startDelayTime;
    private snapCount;
    constructor(context: IMSdkContext, tasks?: IntervalTask[], intervalTime?: number, startDelayTime?: number);
    /**
     * 追加轮询任务
     * @param task
     */
    private appendTask;
    /**
     * 开始执行轮询
     */
    startPolling(task?: IntervalTask): Promise<void>;
    /**
     * 通知执行异步任务
     */
    stopPolling(): Promise<void>;
    /**
     * 实际调度执行任务列表中的任务
     */
    private run;
    private sleep;
}

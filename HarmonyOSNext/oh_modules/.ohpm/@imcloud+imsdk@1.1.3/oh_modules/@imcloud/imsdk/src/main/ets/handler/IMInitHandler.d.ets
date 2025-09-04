import { IMSdkContext } from '../client/IMSdkContext';
import { IMBaseHandler } from './base/IMBaseHandler';
import { RequestItem } from '../request/RequestItem';
export declare class IMInitHandler extends IMBaseHandler {
    private TAG;
    private _inboxType;
    private _isRetry;
    private _initType;
    private maxCursor;
    private stopSync;
    private convCount;
    private msgCount;
    private initPerformRecorder;
    constructor(context: IMSdkContext, inboxType: number);
    stop(): void;
    protected forceHttp(): boolean;
    init(): Promise<void>;
    loadMore(): Promise<void>;
    private afterIMInit;
    private doInit;
    protected isSuccess(item: RequestItem): boolean;
}

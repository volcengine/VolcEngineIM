import { IMLogService } from '@imcloud/imsdk_common';
export declare class NetMonitor {
    private tag;
    private available;
    private _listener;
    set listener(value: OnNetChangeListener | undefined);
    private logger;
    private netConnection;
    constructor(logService: IMLogService);
    checkNet(): void;
    judgeHasNet(): boolean;
    isNetAvailable(): boolean;
}
export interface OnNetChangeListener {
    onNetWorkChanged: (oldAvailable: boolean, newAvailable: boolean) => void;
}

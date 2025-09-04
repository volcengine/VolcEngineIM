import { IMLogService } from '@imcloud/imsdk_common';
import { IIMMonitorDepend } from '../../../api/depend/IIMMonitorDepend';
import { ValueType as ValueType } from "@ohos.data.ValuesBucket";
export declare class BIMMonitorDepends implements IIMMonitorDepend {
    private logService;
    constructor(logService: IMLogService);
    monitorEvent(eventName: string, value: Record<string, ValueType>): void;
}

import { ValueType as ValueType } from "@ohos.data.ValuesBucket";
export interface IIMMonitorDepend {
    monitorEvent(eventName: string, value: Record<string, ValueType>): void;
}

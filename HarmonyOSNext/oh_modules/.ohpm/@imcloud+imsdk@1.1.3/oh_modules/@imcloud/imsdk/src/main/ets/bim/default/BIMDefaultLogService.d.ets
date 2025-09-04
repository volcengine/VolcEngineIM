import { IMLogService } from '@imcloud/imsdk_common';
import { IMDeviceInfo } from '@imcloud/imsdk_common/src/main/ets/api/log/IMDeviceInfo';
import { IMAccessor } from '@imcloud/imsdk_common/src/main/ets/api/IMAccessor';
import { ValueType as ValueType } from "@ohos.data.ValuesBucket";
/**
 * 兜底使用，无实际意义
 */
export declare class BIMDefaultLogService extends IMLogService {
    private imAccessor;
    init(context: Context, imAccessor: IMAccessor): void;
    getDeviceInfo(callback: (deviceInfo: IMDeviceInfo) => void): Promise<void>;
    onEvent(event: string, data: Record<string, ValueType>): void;
    log(level: number, tag: string, content: string): void;
}

import { IMAccessor, IMLogService } from '@imcloud/imsdk_common';
import { BIMWSReporter } from './BIMWSReporter';
import { BIMMessageReporter } from './BIMMessageReporter';
import { BIMNetReporter } from './BIMNetReporter';
import { BIMDBReport } from './BIMDBReport';
import { IMSdkClient } from '../../../../../Index';
import { ValueType as ValueType } from "@ohos.data.ValuesBucket";
/**
 * 事件上报
 */
export declare class BIMReporterManager {
    private TAG;
    wsReporter: BIMWSReporter;
    msgReporter: BIMMessageReporter;
    netReporter: BIMNetReporter;
    dbReporter: BIMDBReport;
    logger: IMLogService;
    imAccess: IMAccessor;
    imsdkClient: IMSdkClient;
    constructor(imAccessor: IMAccessor, logger: IMLogService, imsdkClient: IMSdkClient);
    monitorTeaEvent(event: string, data: Record<string, ValueType>, ignoreSample?: Boolean): void;
    private addCommParam;
    private hasTeaChance;
}

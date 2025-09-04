import { RequestItem } from '../request/RequestItem';
import { IMSdkContext } from './IMSdkContext';
export declare class IMNtpTimeUtils {
    context: IMSdkContext;
    private delta;
    constructor(context: IMSdkContext);
    updateDelta(item: RequestItem): void;
    getServerTime(): number;
}

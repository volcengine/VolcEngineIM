import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
/**
 * CommonHelper
 * 对应Android CommonUtil
 */
export declare class CommonHelper extends IMSdkBaseObject {
    constructor(context: IMSdkContext);
    getTriggerType(reason: number): number;
    verifyPullStrangerByRecent(reason: number): boolean;
    getPullSourceByReason(reason: number): string;
    getStrangerPullSourceByReason(reason: number): string;
}

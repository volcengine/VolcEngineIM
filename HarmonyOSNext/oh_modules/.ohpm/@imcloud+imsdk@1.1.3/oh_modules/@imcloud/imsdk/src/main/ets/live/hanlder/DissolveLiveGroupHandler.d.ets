import { BIMResult, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
/**
 * 解散直播群，仅群主可以调用
 */
export declare class DissolveLiveGroupHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    dissolve(conversationShortId: string): Promise<BIMResult<boolean>>;
}

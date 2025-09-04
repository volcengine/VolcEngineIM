import { BIMResult, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class GetLiveGroupOnlineCountHandler extends IMBaseHandler {
    private TAG;
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    get(conversationShortId: string): Promise<BIMResult<number>>;
}

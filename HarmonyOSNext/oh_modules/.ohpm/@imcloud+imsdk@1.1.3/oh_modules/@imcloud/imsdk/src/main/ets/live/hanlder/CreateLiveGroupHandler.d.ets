import { BIMConversation, BIMResult, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class CreateLiveGroupHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    createWithInfo(map: Map<string, string>, name: string | undefined, url: string | undefined, desc: string | undefined, ntc: string | undefined): Promise<BIMResult<BIMConversation | undefined>>;
}

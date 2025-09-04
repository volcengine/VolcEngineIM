import { BIMResult, im_proto, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class UpdateLiveGroupBlockListHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    doRequest(conversationShortId: string, uidList: string[], uidStrList: string[], blockTime: number, blockAction: im_proto.BlockAction, blockStatus: im_proto.BlockStatus): Promise<BIMResult<boolean>>;
}

import { BIMLiveGroupListResult, BIMResult, im_proto, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class GetLiveGroupListHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    getLiveGroupList(cursor: number, limit: number, policy: im_proto.ConversationsListPolicy): Promise<BIMResult<BIMLiveGroupListResult>>;
    protected isSuccess(item: RequestItem): boolean;
}

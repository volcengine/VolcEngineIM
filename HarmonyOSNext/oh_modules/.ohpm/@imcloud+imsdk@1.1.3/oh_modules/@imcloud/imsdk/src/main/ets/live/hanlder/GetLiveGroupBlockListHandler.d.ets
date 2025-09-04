import { BIMResult } from '../../../../../Index';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
import { RequestItem } from '../../request/RequestItem';
import { BIMLiveMemberListResult } from '../api/model/BIMLiveMemberListResult';
/**
 * 获取黑名单或者禁言名单
 */
export declare class GetLiveGroupBlockListHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    get(conversationShortId: string, cursor: number, limit: number, blockAction: im_proto.BlockAction): Promise<BIMResult<BIMLiveMemberListResult>>;
}

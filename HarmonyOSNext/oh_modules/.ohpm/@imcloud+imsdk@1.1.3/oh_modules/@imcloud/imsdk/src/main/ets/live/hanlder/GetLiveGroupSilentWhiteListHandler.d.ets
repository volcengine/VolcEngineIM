import { BIMResult, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
import { BIMLiveMemberListResult } from '../api/model/BIMLiveMemberListResult';
/**
 * 获取禁言白名单
 */
export declare class GetLiveGroupSilentWhiteListHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    get(conversationShortId: string, cursor: number, limit: number): Promise<BIMResult<BIMLiveMemberListResult>>;
}

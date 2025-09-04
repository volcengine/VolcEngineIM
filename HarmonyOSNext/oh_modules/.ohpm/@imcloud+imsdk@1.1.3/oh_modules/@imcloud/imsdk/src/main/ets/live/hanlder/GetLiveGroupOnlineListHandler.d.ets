import { BIMResult, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
import { BIMLiveMemberListResult } from '../api/model/BIMLiveMemberListResult';
export declare class GetLiveGroupOnlineListHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    load(conversationShortId: string, cursor: number, limit: number, markType: string | undefined): Promise<BIMResult<BIMLiveMemberListResult>>;
}

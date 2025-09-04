import { BIMResult } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
import { RequestItem } from '../../request/RequestItem';
import { BIMLiveMemberListResult } from '../api/model/BIMLiveMemberListResult';
/**
 * 获取群主和管理员成员列表
 */
export declare class GetLiveGroupMemberListHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    get(conversationShortId: string, cursor: number, limit: number): Promise<BIMResult<BIMLiveMemberListResult>>;
}

import { BIMResult, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class UpdateLiveGroupBatchMemberHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    changeRole(conversationShortId: string, uidList: string[], uidStrList: string[], role: number): Promise<BIMResult<boolean>>;
}

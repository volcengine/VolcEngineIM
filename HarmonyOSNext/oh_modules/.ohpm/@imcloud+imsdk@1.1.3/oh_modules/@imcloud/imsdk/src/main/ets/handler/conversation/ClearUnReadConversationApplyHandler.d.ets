import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/***
 * 清空未读群审核数量
 */
export declare class ClearUnReadConversationApplyHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    clearUnReadConversationApply(conversationShortId: bigint): Promise<boolean>;
    private handleResponse;
    protected isSuccess(item: RequestItem): boolean;
}

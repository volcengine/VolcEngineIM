import { IMResult } from '../../api/bean/IMHandlerResult';
import { ConversationAuditSwitchResult } from '../../api/bean/group/ConversationAuditSwitchResult';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/***
 * 待审批的进群审核列表
 */
export declare class GetConversationAuditSwitchHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    /***
     * 异常返回undefined
     */
    getConversationAuditSwitchStatus(conversationShortId: bigint, conversationType: number): Promise<IMResult<ConversationAuditSwitchResult>>;
    private handleResponse;
    protected isSuccess(item: RequestItem): boolean;
}

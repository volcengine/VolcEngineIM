import { IMResult } from '../../api/bean/IMHandlerResult';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/***
 * 获取会话进群审核开关状态
 */
export declare class UpdateConversationAuditSwitchHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    /***
     * 异常返回undefined
     */
    updateConversationAuditSwitchStatusExt(conversationShortId: bigint, conversationType: number, openAuditSwitch: boolean, ext?: Map<string, string>): Promise<IMResult<boolean>>;
    private handleResponse;
    protected isSuccess(item: RequestItem): boolean;
}

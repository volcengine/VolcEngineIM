import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { RequestItem } from '../../request/RequestItem';
import { IMResult } from '../../api/bean/IMHandlerResult';
/**
 * 入群审核 - 发起申请
 */
export declare class SendConversationApplyHandler extends IMBaseHandler {
    constructor(imSdkContext: IMSdkContext);
    /***
     * 异常返回undefined
     */
    sendConversationApply(conversationShortId: bigint, conversationType: number, map?: Map<string, string>): Promise<IMResult<boolean>>;
    protected isSuccess(item: RequestItem): boolean;
    private handleResponse;
}

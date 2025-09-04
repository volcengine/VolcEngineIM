import { ConversationApplyAckResult } from '../../api/bean/group/ConversationApplyAckResult';
import { IMResult } from '../../api/bean/IMHandlerResult';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/**
 * 入群审核 - 审批
 */
export declare class ACKConversationApplyHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    /**
     * @returns 业务body不为空时返回result，请求错误返回undefined
     */
    ackConversationApply(applyId: bigint, status: boolean, ext?: Map<string, string>): Promise<IMResult<ConversationApplyAckResult>>;
    private handleResponse;
    protected isSuccess(item: RequestItem): boolean;
}

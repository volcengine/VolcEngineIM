import { IMResult } from '../../api/bean/IMHandlerResult';
import { ConversationAuditUnReadResult } from '../../api/bean/group/ConversationAuditUnReadResult';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/**
 * 获取最新未读进群审核信息和未读数
 */
export declare class GetConversationAuditUnReadHandlerV2 extends IMBaseHandler {
    constructor(context: IMSdkContext);
    /***
     * 异常返回undefined
     */
    getConversationAuditUnread(withUserPromptInfo: boolean, conversationIdList: bigint[]): Promise<IMResult<ConversationAuditUnReadResult>>;
    private handleResponse;
    protected isSuccess(item: RequestItem): boolean;
}

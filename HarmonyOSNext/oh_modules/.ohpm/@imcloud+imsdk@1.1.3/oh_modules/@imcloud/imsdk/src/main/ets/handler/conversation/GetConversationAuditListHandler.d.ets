import { IMResult } from '../../api/bean/IMHandlerResult';
import { ConversationAuditListResult } from '../../api/bean/group/ConversationAuditListResult';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class GetConversationAuditListHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    getConversationAuditList(cursor: bigint, limit: number, conversationShortId: bigint): Promise<IMResult<ConversationAuditListResult>>;
    private doRequest;
    /***
     * 异常返回undefined
     */
    private handleResponse;
    protected isSuccess(item: RequestItem): boolean;
}

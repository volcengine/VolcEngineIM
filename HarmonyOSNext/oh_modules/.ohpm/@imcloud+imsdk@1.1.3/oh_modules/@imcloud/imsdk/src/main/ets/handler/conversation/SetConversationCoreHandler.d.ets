import { IMResult } from '../../api/bean/IMHandlerResult';
import { Conversation } from '../../api/model/Conversation';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { SetConversationCoreParams } from '../params/SetConversationCoreParams';
export declare class SetConversationCoreHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    updateConversation(params: SetConversationCoreParams): Promise<IMResult<Conversation>>;
    protected handleResponse(reqItem: RequestItem): Promise<Nullable<Conversation>>;
    protected isSuccess(reqItem: RequestItem): boolean;
}

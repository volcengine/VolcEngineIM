import { Conversation } from '../../api/model/Conversation';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class StrangerMarkReadHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    markConversationRead(conversation: Conversation): Promise<Nullable<Conversation>>;
    private updateConversation;
    private doRequest;
    private handleResponse;
}

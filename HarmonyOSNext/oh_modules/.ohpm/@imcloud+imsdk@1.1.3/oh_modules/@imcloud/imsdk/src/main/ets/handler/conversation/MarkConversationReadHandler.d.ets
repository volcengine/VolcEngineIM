import { Conversation } from '../../api/model/Conversation';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class MarkConversationReadHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    markConversationRead(conversation: Conversation): Promise<Conversation | undefined>;
    private updateConversation;
    private doRequest;
    private handleResponse;
}

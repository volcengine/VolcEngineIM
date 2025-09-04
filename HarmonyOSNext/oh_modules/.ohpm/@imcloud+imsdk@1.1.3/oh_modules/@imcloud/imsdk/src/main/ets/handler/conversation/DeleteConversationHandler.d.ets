import { IMResult } from '../../api/bean/IMHandlerResult';
import { Conversation } from '../../api/model/Conversation';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
/**
 * TODO: jw 优化一下代码可读性
 */
export declare class DeleteConversationHandler extends IMBaseHandler {
    private readonly isStranger;
    constructor(context: IMSdkContext, stranger: boolean);
    get tag(): string;
    delete(convId: string, isLocal: boolean): Promise<IMResult<string>>;
    doDeleteReq(result: IMResult<string | boolean>, conversation: Conversation, maxIndexV1: bigint, isMarkDelete?: boolean): Promise<Nullable<string>>;
    private deleteNormally;
    private deleteStrange;
    private handleResponse;
    private deleteDBConversation;
    markDelete(conversation: Conversation): Promise<boolean>;
}

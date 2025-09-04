import { Message } from '../../api/model/Message';
import { Conversation } from '../../api/model/Conversation';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class GetMessageByIdHandler extends IMBaseHandler {
    private saveToDB;
    constructor(context: IMSdkContext, saveIntoDB: boolean);
    get tag(): string;
    protected forceHttp(): boolean;
    get(msgId: bigint, conversation: Conversation): Promise<Nullable<GetMessageByIdHandlerResult>>;
    handleResponse(item: RequestItem): Promise<GetMessageByIdHandlerResult>;
    isSuccess(item: RequestItem): boolean;
}
export interface GetMessageByIdHandlerResult {
    success?: boolean;
    errorCode?: number;
    isFromDB?: boolean;
    message?: Message;
}

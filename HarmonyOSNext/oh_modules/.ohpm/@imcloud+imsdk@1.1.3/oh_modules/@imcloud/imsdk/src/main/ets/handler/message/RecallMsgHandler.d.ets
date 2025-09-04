import { IMResult } from '../../api/bean/IMHandlerResult';
import { Message } from '../../api/model/Message';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class RecallMsgHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    recall(msg: Message): Promise<IMResult<Message>>;
    private buildAndSendRequest;
    private handleResponse;
    private handleRecallAfterResponse;
    private processRecall;
    private afterProcessRecall;
}

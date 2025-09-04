import { Conversation } from '../../../api/model/Conversation';
import { BIMResult } from '../../../bim/api/model/BIMResult';
import { IMSdkContext } from '../../../client/IMSdkContext';
import { IMBaseHandler } from '../../base/IMBaseHandler';
export declare class MarkBatchConversationReadHandler extends IMBaseHandler {
    private readonly TAG;
    constructor(context: IMSdkContext);
    markAll(): Promise<BIMResult<boolean>>;
    protected forceHttp(): boolean;
    markConversationList(conversationList: Conversation[]): Promise<BIMResult<boolean>>;
    private clearUnRead;
    private doRequest;
    private updateConvList;
}

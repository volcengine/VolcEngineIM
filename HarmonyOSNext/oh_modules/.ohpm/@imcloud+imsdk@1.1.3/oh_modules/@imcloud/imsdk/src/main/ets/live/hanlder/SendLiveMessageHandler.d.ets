import { BIMConversation, BIMMessage, BIMMessagePriority, BIMResult, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class SendLiveMessageHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    private TAG;
    private message;
    private metrics;
    private bimClient;
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    addOrClearLocalExt(msg: BIMMessage, key: string, value: string): void;
    sendMessage(message: BIMMessage, conversation: BIMConversation, priority: BIMMessagePriority): Promise<BIMResult<BIMMessage>>;
    private getSendErrorCode;
    private reportLiveSendIMEvent;
}

import { IMBaseHandler } from '../base/IMBaseHandler';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { Message } from '../../api/model/Message';
import { BIMSendCallback } from '../../bim/api/interface/BIMSendCallback';
import { SendTrace } from '../../bim/report/BIMMessageReporter';
/**
 * SendMsgHandler
 */
export declare class SendMsgHandler extends IMBaseHandler {
    private pushMessage;
    private isResponseHandled;
    private sendCallback;
    constructor(context: IMSdkContext);
    get tag(): string;
    send(msg: Message, sendCallback: BIMSendCallback, sendTrace?: SendTrace): Promise<boolean>;
    private saveMsg;
    private afterSaveMsg;
    private updateReference;
    private getSendMessageRequestBody;
    private handleResponse;
    private processResponse;
    protected isSuccess(item: RequestItem): boolean;
    private addOrClearLocalExt;
    /**
     * 收到在线消息之后记录一下该消息，是为了在一个兜底的场景下确保逻辑自洽：在线消息先于发送消息成功的回调
     * @param message
     */
    handleSendMsgByPush(message: Message): boolean;
    private getPushMsgLogInfo;
    private getBIMErrorCode;
}

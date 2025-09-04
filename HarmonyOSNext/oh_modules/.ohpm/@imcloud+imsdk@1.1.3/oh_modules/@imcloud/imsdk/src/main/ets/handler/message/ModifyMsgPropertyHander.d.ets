import { IMResult } from '../../api/bean/IMHandlerResult';
import { ModifyMsgPropertyMsg } from '../../api/model/MessageProperty';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/**
 * send =>    doSend -> handleResponse ->    =>  onResultCallback
 *            ⬆️                        ⬇️
 *            |                         |
 *             ---------   ⬅️  ---------
 *
 * 最后通过参数message的status参数决定请求的成功和失败
 */
export declare class ModifyMsgPropertyHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    send(msg: Nullable<ModifyMsgPropertyMsg>): Promise<IMResult<ModifyMsgPropertyMsg>>;
    private onResultCallback;
    private doSend;
    private getLocalPropertyItems;
    handleResponse(item: RequestItem, message: ModifyMsgPropertyMsg, result: IMResult<ModifyMsgPropertyMsg>): Promise<ModifyMsgPropertyMsg>;
    isSuccess(item: RequestItem): boolean;
}

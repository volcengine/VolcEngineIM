import { IMResult } from '../../api/bean/IMHandlerResult';
import { Message } from '../../api/model/Message';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/**
 * 编辑消息内容
 */
export declare class ModifyMessageHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    modifyMessageContent(convId: string, msgUuid: string, newMsgContent: string, extMap: Nullable<Map<string, string>>): Promise<IMResult<Message>>;
    protected isSuccess(item: RequestItem): boolean;
    private handleResponse;
}

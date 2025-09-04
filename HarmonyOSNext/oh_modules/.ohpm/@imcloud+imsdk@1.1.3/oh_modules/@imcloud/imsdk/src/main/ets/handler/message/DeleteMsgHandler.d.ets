import { Message } from '../../api/model/Message';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class DeleteMsgHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    delete(msg: Message, isLocal?: boolean): Promise<Nullable<Message>>;
    /**
     * 批量删除消息
     * @param conversationId
     * @param msgList
     * @param isLocal
     * @returns
     */
    batchDeleteMessage(conversationId: string, msgList: Message[], isLocal?: boolean): Promise<Nullable<boolean>>;
    private afterDelete;
    private notifyDeleteConversation;
    private notifyUpdateConversation;
    private notifyDeleteMsg;
    private deleteMsgFromDb;
    private handleDeleteStrangerMsg;
    private handleDeleteNormalMsg;
    private sendDeleteMsgRequest;
}

import { Conversation } from '../../api/model/Conversation';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { RequestItem } from '../../request/RequestItem';
import { ConversationInfoUpdateParams } from '../../helper/WaitChecker';
export declare class GetConversationInfoListHandler extends IMBaseHandler {
    private params;
    constructor(context: IMSdkContext, params: ConversationInfoUpdateParams);
    get tag(): string;
    protected forceHttp(): boolean;
    static get(context: IMSdkContext, inbox: number, msgMap: Map<string, im_proto.IMessageBody>, params: ConversationInfoUpdateParams): Promise<Conversation[]>;
    getInner(inboxType: number, msgMap: Map<string, im_proto.IMessageBody>): Promise<Nullable<Conversation[]>>;
    private handleResponse;
    onResponseResult(conversationList: Nullable<Conversation[]>, inboxType: number, item: RequestItem, msgMap: Map<string, im_proto.IMessageBody>): Promise<void>;
    protected isSuccess(reqItem: RequestItem): boolean;
}

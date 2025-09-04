import { Conversation } from '../../api/model/Conversation';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class GetSubConversationInfoListHandler extends IMBaseHandler {
    private fromInit;
    constructor(context: IMSdkContext, fromInit: boolean);
    get tag(): string;
    protected forceHttp(): boolean;
    static get(context: IMSdkContext, inbox: number, msgMap: Map<string, im_proto.IMessageBody>, fromInit: boolean): void;
    getInner(inboxType: number, msgMap: Map<string, im_proto.IMessageBody>): Promise<Nullable<Conversation[]>>;
    isSuccess(item: RequestItem): boolean;
    private handleResponse;
    onResponseResult(conversationList: Nullable<Conversation[]>): Promise<void>;
}

import { IMResult } from '../../api/bean/IMHandlerResult';
import { Conversation } from '../../api/model/Conversation';
import { Message } from '../../api/model/Message';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class GetSpecifiedMsgListHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    get(convId: string, type: im_proto.ConversationMessageListType, offset: bigint, count: bigint): Promise<IMResult<GetSpecifiedMsgResult>>;
    handleResponse(item: RequestItem, conversation: Conversation): Promise<Nullable<GetSpecifiedMsgResult>>;
    isSuccess(item: RequestItem): boolean;
}
export declare class GetSpecifiedMsgResult {
    success: Nullable<boolean>;
    msgList: Nullable<Message[]>;
    hasMore: Nullable<boolean>;
    nextCursor: Nullable<bigint>;
}

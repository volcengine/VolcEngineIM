import Long from 'long';
import { Conversation } from '../../api/model/Conversation';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { GetGroupConversationListParams } from '../params/GetGroupConversationListParams';
export declare class GetGroupConversationListHandler extends IMBaseHandler {
    inboxType: number;
    constructor(inboxType: number, context: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    getJoinedGroupList(cursor: Long, sortType: im_proto.SortType): Promise<Nullable<Conversation[]>>;
    getOwnedGroupList(cursor: Long, sortType: im_proto.SortType): Promise<Nullable<Conversation[]>>;
    getGroupList(params: GetGroupConversationListParams): Promise<Nullable<Conversation[]>>;
    handleResponse(item: RequestItem): Promise<Conversation[]>;
    isSuccess(item: RequestItem): boolean;
}

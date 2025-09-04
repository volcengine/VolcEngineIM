import { im_proto } from '../api/proto';
import { IMSdkContext } from '../client/IMSdkContext';
import { RequestItem } from '../request/RequestItem';
import { IMBaseHandler } from './base/IMBaseHandler';
import { GetUserMsgParams } from './params/GetUserMsgParams';
import HashMap from "@ohos.util.HashMap";
import { Conversation } from '../api/model/Conversation';
export declare class GetUserMsgHandler extends IMBaseHandler {
    private TAG;
    private _inboxType;
    private _params;
    private _cursor;
    constructor(context: IMSdkContext, inboxType: number, params: GetUserMsgParams);
    startPull(): Promise<boolean>;
    private loadMore;
    handleResponse(item: RequestItem): Promise<void>;
    allEnd(success: boolean): Promise<void>;
    processBadgeCountInfoList(responseBody: im_proto.IMessagesPerUserResponseBody): HashMap<string, im_proto.IConversationBadgeCountInfo>;
    protected isSuccess(item: RequestItem): boolean;
    protected forceHttp(): boolean;
}
export declare class SaveConvResult {
    conversation?: Conversation;
    isNew?: boolean;
    isUpdateStranger?: boolean;
    success?: boolean;
}

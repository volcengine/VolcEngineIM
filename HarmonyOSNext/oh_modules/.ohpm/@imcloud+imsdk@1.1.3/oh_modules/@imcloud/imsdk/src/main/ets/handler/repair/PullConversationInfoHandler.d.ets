import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/**
 * 批量拉取会话信息，用于会话完整性修复逻辑
 */
export declare class PullConversationInfoHandler extends IMBaseHandler {
    private _BATCH_SIZE;
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    pull(inbox: number, checkInfoList: Nullable<im_proto.ConversationCheckInfo[]>): Promise<void>;
    private doSendRequest;
    handleResponse(inbox: number, item: RequestItem): Promise<void>;
    isSuccess(item: RequestItem): boolean;
}

import { BIMResult, im_proto, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class UpdateLiveGroupSilentWhiteListHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    updateWhiteList(conversationShortId: string, uidList: string[], uidStrList: string[], action: im_proto.updateBlockConversationWhiteMemberListAction): Promise<BIMResult<boolean>>;
}

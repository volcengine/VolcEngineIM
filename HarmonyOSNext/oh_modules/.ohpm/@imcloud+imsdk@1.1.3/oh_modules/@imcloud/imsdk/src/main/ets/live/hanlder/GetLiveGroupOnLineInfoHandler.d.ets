import { BIMResult } from "../../../../../Index";
import { IMSdkContext } from "../../client/IMSdkContext";
import { IMBaseHandler } from "../../handler/base/IMBaseHandler";
import { RequestItem } from "../../request/RequestItem";
import { BIMLiveMemberOnlineInfo } from "../api/model/BIMLiveMemberOnlineInfo";
export declare class GetLiveGroupOnLineInfoHandler extends IMBaseHandler {
    private TAG;
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    get(conversationShortId: string, uidList: string[], uidStrList: string[]): Promise<BIMResult<BIMLiveMemberOnlineInfo[]>>;
}

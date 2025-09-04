import Long from "long";
import { BIMResult, RequestItem } from "../../../../../Index";
import { IMSdkContext } from "../../client/IMSdkContext";
import { IMBaseHandler } from "../../handler/base/IMBaseHandler";
import { BIMLiveMsgBodyListResult } from "../api/model/BIMLiveMsgBodyListResult";
export declare class GetLiveGroupMessageHandler extends IMBaseHandler {
    private TAG;
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    get(conversationShortId: string, curIndexV2: Long, limit: Long): Promise<BIMResult<BIMLiveMsgBodyListResult>>;
}

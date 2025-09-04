import { BIMResult, RequestItem } from "../../../../../Index";
import { IMSdkContext } from "../../client/IMSdkContext";
import { IMBaseHandler } from "../../handler/base/IMBaseHandler";
import { BIMLiveMessageListResult } from "../api/model/BIMLiveMessageListResult";
export declare class GetLiveGroupHistoryMessageHandler extends IMBaseHandler {
    private TAG;
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    getHistory(shortId: string, cursor: number, limit: number): Promise<BIMResult<BIMLiveMessageListResult>>;
}

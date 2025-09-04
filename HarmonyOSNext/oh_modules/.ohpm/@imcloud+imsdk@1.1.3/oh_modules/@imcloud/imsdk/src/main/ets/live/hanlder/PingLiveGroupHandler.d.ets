import Long from "long";
import { BIMMessage, BIMResult, RequestItem } from "../../../../../Index";
import { IMSdkContext } from "../../client/IMSdkContext";
import { IMBaseHandler } from "../../handler/base/IMBaseHandler";
/**
 * 直播间 ping
 * ping 成功返回当前群最后一条消息
 */
export declare class PingLiveGroupHandler extends IMBaseHandler {
    private TAG;
    private conversationShortId;
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    ping(conversationShortId: string): Promise<BIMResult<PingResult | undefined>>;
}
export declare class PingResult {
    bimMessage: BIMMessage;
    onLineCount: Long;
    constructor(bimMessage: BIMMessage, onLineCount: Long);
}

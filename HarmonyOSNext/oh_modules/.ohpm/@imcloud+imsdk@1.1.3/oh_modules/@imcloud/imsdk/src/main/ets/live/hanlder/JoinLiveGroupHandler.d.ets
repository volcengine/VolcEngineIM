import Long from "long";
import { BIMConversation, BIMResult, MemberUpdateInfo, RequestItem } from "../../../../../Index";
import { IMSdkContext } from "../../client/IMSdkContext";
import { IMBaseHandler } from "../../handler/base/IMBaseHandler";
export declare class JoinLiveGroupHandler extends IMBaseHandler {
    private TAG;
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    join(shortId: Long, isRejoin: boolean): Promise<BIMResult<JoinResult | undefined>>;
    joinWithInfo(shortId: Long, info: MemberUpdateInfo | undefined): Promise<BIMResult<JoinResult | undefined>>;
    realJoin(shortId: Long, isRejoin: boolean, info: MemberUpdateInfo | undefined): Promise<BIMResult<JoinResult | undefined>>;
}
export declare class JoinResult {
    conversation: BIMConversation;
    oldestIndexV2: Long;
    constructor(conversation: BIMConversation, oldestIndexV2: Long);
}

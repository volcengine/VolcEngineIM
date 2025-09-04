import { BIMResult, RequestItem } from "../../../../../Index";
import { IMSdkContext } from "../../client/IMSdkContext";
import { IMBaseHandler } from "../../handler/base/IMBaseHandler";
export declare class RemoveLiveGroupHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    remove(conversationShorId: string, uidList: string[], uidStrList: string[]): Promise<BIMResult<boolean>>;
}

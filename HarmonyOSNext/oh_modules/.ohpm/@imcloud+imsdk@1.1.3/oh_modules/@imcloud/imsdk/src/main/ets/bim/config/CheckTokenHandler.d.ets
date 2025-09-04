import Long from "long";
import { RequestItem } from "../../../../../Index";
import { IMSdkContext } from "../../client/IMSdkContext";
import { IMBaseHandler } from "../../handler/base/IMBaseHandler";
export declare class CheckTokenHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    checkToken(appid: number, uid: Long): Promise<boolean>;
    protected isSuccess(item: RequestItem): boolean;
}

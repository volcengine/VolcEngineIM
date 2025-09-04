import { BIMClient } from '../../bim/api/BIMClient';
import { IMSdkContext } from '../../client/IMSdkContext';
export declare class CheckConversationMsgHelper {
    readonly tag = "CheckMsg";
    context: IMSdkContext | undefined;
    private logger;
    check(cid: string): void;
    constructor(imClient: BIMClient);
}

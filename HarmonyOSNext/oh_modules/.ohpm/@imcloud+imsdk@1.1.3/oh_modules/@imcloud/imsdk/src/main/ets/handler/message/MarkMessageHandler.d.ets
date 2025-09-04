import { im_proto } from '../../api/proto';
import { BIMResult } from '../../bim/api/model/BIMResult';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class MarkMessageHandler extends IMBaseHandler {
    private readonly markTag;
    constructor(context: IMSdkContext);
    markMessage(cid: string, messageId: bigint, type: im_proto.ActionType, isMark: boolean, sortTime: number, tag: number): Promise<BIMResult<boolean>>;
}

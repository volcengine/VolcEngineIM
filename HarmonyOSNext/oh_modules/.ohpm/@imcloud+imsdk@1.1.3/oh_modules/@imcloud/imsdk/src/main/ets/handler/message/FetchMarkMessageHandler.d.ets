import { im_proto } from '../../api/proto';
import { BIMResult } from '../../bim/api/model/BIMResult';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { BIMMessage } from '../../bim/api/model/BIMMessage';
/**
 * 标记消息结果
 */
export declare class BIMMarkMessageListLoadResult {
    msgList?: BIMMessage[];
    msgExtraInfos?: Map<string, string>;
    nextCursor?: bigint;
    success?: boolean;
    hasMore?: boolean;
}
export declare class FetchMarkMessageHandler extends IMBaseHandler {
    private readonly markTag;
    constructor(context: IMSdkContext);
    fetchMarkedMessage(cid: string, type: im_proto.ActionType, tag: number, asc: boolean, cursor: bigint, limit: number, clearUnreadCount: boolean): Promise<BIMResult<BIMMarkMessageListLoadResult>>;
}

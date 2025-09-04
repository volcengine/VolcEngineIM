import { Message } from '../../api/model/Message';
import { im_proto } from '../../api/proto/index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { Range } from '../../manager/RecentLinkRangeManager';
import { RangeList } from '../../model/LeakMsgRepairedRangeStore';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { LoadMsgByIndexV1Params } from '../params/LoadMsgByIndexV1Params';
/***
 * 历史产物，鸿蒙时代不再需要. 请使用LoadMsgByIndexV2RangeHandler
 */
export declare class LeakMsgRepairToOldHandler extends IMBaseHandler {
    params: LoadMsgByIndexV1Params;
    repairInfo: LeakMsgRepairToOldInfo;
    pullTime: number;
    constructor(context: IMSdkContext, loadParam: LoadMsgByIndexV1Params);
    get tag(): string;
    protected isSuccess(reqItem: RequestItem): boolean;
    pull(): Promise<LeakMsgRepairToOldInfo | undefined>;
    private doPull;
    protected handleResponse(item: RequestItem): Promise<void>;
    repairOpt(msgInfoList: im_proto.IMessageBody[]): Promise<boolean>;
}
export declare class LeakMsgRepairToOldInfo extends IMSdkBaseObject {
    isSuccess: boolean;
    reachBase: boolean;
    reachLocal: boolean;
    pullTimes: number;
    msgCount: number;
    validMsgCount: number;
    leakMsgCount: number;
    repairedRanges: Range[];
    repairedRangeList: RangeList;
    msgList: Message[];
    constructor(context: IMSdkContext);
    addRepairedRange(range: Range): void;
    get str(): string;
}

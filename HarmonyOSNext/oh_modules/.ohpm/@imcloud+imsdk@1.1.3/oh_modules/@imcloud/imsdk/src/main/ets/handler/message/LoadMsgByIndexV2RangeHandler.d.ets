import { Message } from '../../api/model/Message';
import { im_proto } from '../../api/proto/index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { Range } from '../../manager/RecentLinkRangeManager';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { LoadMsgByIndexV2RangeParams } from '../params/LoadMsgByIndexV2RangeParams';
export declare class LoadMsgByIndexV2RangeHandler extends IMBaseHandler {
    params: LoadMsgByIndexV2RangeParams;
    result: LoadMsgByIndexV2RangeResult;
    constructor(context: IMSdkContext, loadParam: LoadMsgByIndexV2RangeParams);
    get tag(): string;
    protected forceHttp(): boolean;
    protected isSuccess(reqItem: RequestItem): boolean;
    pull(): Promise<LoadMsgByIndexV2RangeResult>;
    private doPull;
    protected handleResponse(item: RequestItem): Promise<void>;
    saveMessage(msgInfoList: im_proto.IMessageInfo[]): Promise<Message[]>;
}
export declare class LoadMsgByIndexV2RangeResult extends IMSdkBaseObject {
    direction: number;
    isFullSuccess: boolean;
    originToCheckRange: Range;
    toCheckRange: Range;
    checkedRange: Range;
    msgList: Message[];
    constructor(context: IMSdkContext, direction: number, minIndexV2: bigint, maxIndexV2: bigint);
    processCheckedResult(convId: string, msgList: Message[], hasMore: boolean, nextIndexV2: Nullable<bigint>): void;
    get str(): string;
}

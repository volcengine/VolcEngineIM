import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { Range } from '../manager/RecentLinkRangeManager';
import { RangeList } from './LeakMsgRepairedRangeStore';
import { Message } from '../api/model/Message';
export declare class LeakMsgRepairModel extends IMSdkBaseObject {
    private repairInfo;
    private dataSource;
    constructor(context: IMSdkContext);
    static storeRangeByLeak(baseObj: IMSdkBaseObject, convId: string, sourceRange: Range, leakRanges: Range[]): Promise<void>;
    static storeContinueRange(baseObj: IMSdkBaseObject, convId: string, range: Range, source: string): Promise<void>;
    triggerRepair(convId: string): Promise<Nullable<Message[]>>;
    /**
     * 根据本地的多段连续区间进行消息补洞
     * @param convId
     * @param repairedRangeList
     * @returns
     */
    repairRange(convId: string, repairedRangeList: RangeList): Promise<Message[]>;
    /**
     * 给定一个连续区间repairedRange进行消息空洞修复
     * @param convId 会话ID
     * @param repairedRange 连续区间
     * @returns
     */
    repairDB(convId: string, repairedRange?: Range): Promise<Nullable<Message[]>>;
    fullRepairDB(convId: string): Promise<Nullable<Message[]>>;
    repairDBNewer(convId: string, startIndex: bigint): Promise<[string, Message[]]>;
    /**
     * 补洞逻辑1: 给定消息indexV2，尝试修复[baseIndex,indexV2]之间的消息空洞
     * baseIndex一般为1，在历史兼容情况下，由于历史架构原因，存在历史老消息不支持indexV2、即indexV2仅为对象初始化的默认值-1. 因此为兼容那些历史老消息，设计了baseIndex。业务可不深究
     * @param convId 会话id
     * @param startIndex 当前会话数据库里面的最大的indexV2，作为起点往历史消息方向查询修复消息空洞
     */
    repairDBOlder(convId: string, startIndex: bigint): Promise<Nullable<Message[]>>;
    /**
     * 构造缺失区间之后去拉缺失区间的消息
     * @param convId
     * @param leakRanges
     * @returns
     */
    repairByRange(convId: string, leakRanges: Range[]): Promise<[string, Message[]] | undefined>;
    /**
     * @param indexList asc排序好的indexV2消息列表
     * @param start 从start开始递增遍历
     * @param end 遇到end时终止遍历
     * @returns 返回[start,end]下标区间中缺失消息indexV2组成的列表leakIndexList
     */
    findLeakIndexList(indexList: bigint[], start: bigint, end: bigint): bigint[];
    /**
     * @param leakIndexList 缺失消息列表
     * @param convId 会话id
     * @returns 构造缺失消息区间用于接口请求，避免一次性请求过多消息，因此需要对缺失区间进行一些限制
     * 目前的限制条件为：最大不超过40、最小不低于8
     */
    findLeakRangeByLeakIndex(leakIndexList: bigint[], convId: string): Range[];
    mergeLeakRange(leakRanges: Range[]): Range[];
}

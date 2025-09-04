import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { Range } from '../manager/RecentLinkRangeManager';
/**
 * 空洞消息修复后的连续区间内存缓存已经磁盘缓存类
 */
export declare class LeakMsgRepairedRangeStore extends IMSdkBaseObject {
    private static MAX_LRU;
    private readonly lruCache;
    constructor(context: IMSdkContext);
    update(convId: string, rangeList: RangeList): Promise<boolean>;
    get(convId: string): Promise<RangeList>;
    delete(convId: string): Promise<boolean>;
}
export declare class RangeList extends IMSdkBaseObject {
    static TAG: string;
    static MAX_MERGE_LEAK_RANGE_SIZE: number;
    static MAX_MERGE_LEAK_DUPLICATE_SIZE: number;
    rangeList: Range[];
    constructor(context: IMSdkContext, rangeList: Range[]);
    check(index: bigint): boolean;
    /**
     * 检查toCheckRange是否已经作为连续区间的子集
     * @param toCheckRange
     * @returns
     */
    static checkRange(rangeList: Range[], toCheckRange: Range): boolean;
    merge(range: Range): void;
    getMaxRange(): Range;
    static compare(a: Range, b: Range): 0 | 1 | -1;
    static getRangeListStr(rangeList: Range[]): string;
    static stringify(key: ESObject, value: ESObject): ESObject;
    static parse(key: ESObject, value: ESObject): ESObject;
}

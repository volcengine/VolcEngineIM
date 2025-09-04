import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare class Range {
    start: bigint;
    end: bigint;
    static MAX_VALUE: bigint;
    static MIN_VALUE: bigint;
    constructor(start: bigint, end: bigint);
    merge(range: Range): void;
    get isValid(): boolean;
    reverse(): void;
    static str(range: Range): string;
}
export declare class RecentLinkRangeManager extends IMSdkBaseObject {
    pullTimeCount: number;
    private localRangeList;
    constructor(context: IMSdkContext);
    /**
     * 从PreferencesService加载
     * @param inboxType
     */
    load(inboxType: number): Promise<Range[]>;
    /**
     * 保存到PreferencesService
     * @param inboxType
     */
    saveLocalRangeList(inboxType: number): Promise<Range[]>;
    getLocalRangeList(inboxType: number): Promise<Range[]>;
    /**
     * 向前扩展指定 index range 的区间
     */
    extendRangeStart(index: number, extendIndex: bigint): void;
    /**
     * 向后扩展指定 index range 的区间
     */
    extendRangeEnd(index: number, extendIndex: bigint): void;
    addToList(remoteRange: Range): Range[];
    checkIndexInList(edge: Nullable<bigint>): number;
    checkMergeLocalRangeList(): Range[];
    searchSmallestLeakRange(from: string): Nullable<Range>;
    searchLargestLeakRange(from: string): Nullable<Range>;
    /**
     * 根据preVersion、curVersion和nextVersion将curVersion合并到区间中
     * 1. 不连续时单点插入curVersion
     * 2. 与preVersion连续时在preVersion所在range中扩展
     * 3. 与preVersion和nextVersion连续时补上空洞
     */
    addCurVersionToList(preVersion: bigint, curVersion: bigint, nextVersion: bigint): void;
}

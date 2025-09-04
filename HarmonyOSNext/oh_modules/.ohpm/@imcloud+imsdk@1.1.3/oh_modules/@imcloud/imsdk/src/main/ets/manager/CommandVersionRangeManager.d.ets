import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { Range } from './RecentLinkRangeManager';
export declare enum VersionRangeTypeEnum {
    CMD = 0,
    MARK_READ = 1
}
export declare class CommandVersionRangeManager extends IMSdkBaseObject {
    readonly cmdIndexRange: CommandVersionRange;
    readonly markReadIndexRange: CommandVersionRange;
    constructor(context: IMSdkContext);
    onInstanceDestroy(): void;
}
export declare class CommandVersionRange extends IMSdkBaseObject {
    private rangeListCache;
    private versionType;
    constructor(context: IMSdkContext, versionType: VersionRangeTypeEnum);
    /**
     * 在index对应的range内向前扩展extendVersion
     */
    extendRangeStart(index: number, extendVersion: bigint): void;
    /**
     * 在index对应的range内向后扩展extendVersion
     */
    extendRangeEnd(index: number, extendVersion: bigint): void;
    /**
     * 将index对应的range的右端回滚为preVersion
     */
    rollbackRangeEnd(index: number, version: bigint, preVersion: bigint): void;
    /**
     * 合并相邻区间
     */
    checkMergeRangeList(): void;
    /**
     * 持久化区间列表
     */
    storeRangeList(inboxType: number): Promise<void>;
    /**
     * 实现具体的持久化方式
     */
    protected storeVersionRangeJSON(inboxType: number): Promise<void>;
    private loadVersionRangeJSON;
    /**
     * 首次获取从本地持久化数据中加载，后续获取直接读缓存
     */
    getRangeList(inboxType: number): Promise<Range[]>;
    /**
     * 从本地持久化数据中加载rangeList
     */
    loadRangeList(inboxType: number): Promise<Range[]>;
    /**
     * 保存命令消息水位
     * @param nextCmdIndex
     * @param inboxType
     */
    setCmdIndex(nextCmdIndex: bigint, inboxType: number): Promise<void>;
    /**
     * 插入一个区间到区间列表中
     * @param range
     * @returns
     */
    addToList(range: Range): Range[];
    /**
     * 根据preVersion、curVersion和nextVersion将curVersion合并到区间中
     * 1. 不连续时单点插入curVersion
     * 2. 与preVersion连续时在preVersion所在range中扩展
     * 3. 与preVersion和nextVersion连续时补上空洞
     */
    addCurVersionToList(preVersion: Nullable<bigint>, curVersion: Nullable<bigint>, nextVersion: Nullable<bigint>): void;
    /**
     * 获取当前最大的一个空洞区间
     */
    searchLargestLeakRange(): Nullable<Range>;
    /**
     * 获取当前最小的一个空洞区间
     */
    searchSmallestLeakRange(): Nullable<Range>;
    /**
     * 获取version在所在区间的index
     */
    checkIndexInList(version: Nullable<bigint>): number;
    /**
     * 重置缓存
     */
    onInstanceDestroy(): void;
}

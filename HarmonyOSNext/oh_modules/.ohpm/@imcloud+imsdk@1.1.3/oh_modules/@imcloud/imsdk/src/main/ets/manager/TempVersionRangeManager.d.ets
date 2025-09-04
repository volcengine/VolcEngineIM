import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare class TempVersionRangeManager extends IMSdkBaseObject {
    readonly recentTempVersionRange: TempVersionRange;
    readonly cmdTempVersionRange: TempVersionRange;
    readonly markReadTempVersion: TempVersionRange;
    /**
     * 切换账号时重置
     */
    onInstanceDestroy(): void;
    constructor(context: IMSdkContext);
}
export declare class TempVersionRange extends IMSdkBaseObject {
    private processingVersionList;
    constructor(context: IMSdkContext);
    /**
     * 理论上preVersion和curVersion是以链表的方式向后延伸的，后一个节点来的时候再尝试更新前一个节点的nextVersion
     */
    addToProcessing(preVersion: Nullable<bigint>, curVersion: Nullable<bigint>): void;
    /**
     * 判断当前version是否正在处理中
     */
    isProcessing(curVersion: Nullable<bigint>): boolean;
    /**
     * 将当前version从正在处理中移除
     */
    removeFromProcessing(curVersion: Nullable<bigint>): Nullable<ProcessingVersion>;
    /**
     * 切换账号时重置
     */
    onInstanceDestroy(): void;
}
export declare class ProcessingVersion {
    preVersion: bigint;
    curVersion: bigint;
    nextVersion: bigint;
    constructor(preVersion: bigint, curVersion: bigint, nextVersion?: Nullable<bigint>);
    toString(): string;
}

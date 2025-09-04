import { CrashLib } from './CrashLib';
import faultLogger from '@ohos.faultLogger';
import { HashMap } from '@kit.ArkTS';
/**
 * 解析Tombstone
 */
export default class Tombstone {
    mFile: string;
    mSignal: string;
    mBacktrace: string;
    mCrashMessage: string;
    mCrashLibs: CrashLib[];
    mBuildIds: HashMap<string, string>;
    mPid: string;
    mTid: string;
    mProcessName: string;
    mThreadName: string;
    mSignalStr: string;
    mSignalNumber: number;
    mCodeStr: string;
    mCodeNumber: number;
    mFatalAddress: string;
    constructor(d9: string);
    getPid(): string;
    getProcessName(): string;
    getTid(): string;
    getThreadName(): string;
    getSignal(): string;
    getBacktrace(): string;
    getMessage(): string;
    getCrashLib(): CrashLib[];
    rebuildTombstone(t7: faultLogger.FaultLogInfo): void;
    private parseBacktrace;
    private registerFormat;
}

import faultLogger from '@ohos.faultLogger';
import Storage from './Storage';
import Header from './Header';
import { NpthTags } from './NpthTags';
import { CrashLib } from './CrashLib';
import AllThread from './AllThread';
/**
 * @madewei
 * @date 2023/11/17
 */
export declare class Body {
    header: Header;
    filters: NpthTags;
    storage: Storage | undefined;
    data: string;
    logcat: string[];
    anr_info: string;
    reason: string;
    module: string;
    summary: string;
    crash_type: string;
    release_build: string;
    process_name: string;
    crash_thread_name: string;
    is_root: string;
    crash_time: number;
    app_start_time: number;
    pid: number;
    uid: number;
    battery: number;
    is_background: boolean;
    crash_lib_uuid: CrashLib[] | undefined;
    cpu_usage: number;
    all_thread_stacks: AllThread | undefined;
    module_name: string | undefined;
    custom: object;
    sdk_info: object;
    plugin_info: object[];
    constructor(l5: faultLogger.FaultType, m5: Header);
    /**
     * 处理FaultLogInfo（不一定有）
     * @param crashType
     * @param fatal
     */
    addFaultLogInfo(y4: Context, z4: string, a5: faultLogger.FaultLogInfo): void;
}
export default Body;

import faultLogger from '@ohos.faultLogger';
import Storage from './Storage';
import { JsCrash } from './JsCrash';
import * as CrashType from './CrashType';
import { NpthTags } from './NpthTags';
import process from '@ohos.process';
import deviceInfo from '@ohos.deviceInfo';
import AppFreeze from './AppFreeze';
import Folder from '../Folder';
import Tombstone from './Tombstone';
import { FileUtils } from '../../../../bytedance/hpem/util/FileUtils';
export class Body {
    constructor(l5, m5) {
        this.storage = undefined;
        this.data = '';
        this.logcat = [];
        this.anr_info = '';
        this.reason = '';
        this.module = '';
        this.summary = '';
        this.crash_type = '';
        this.release_build = '';
        this.process_name = '';
        this.crash_thread_name = '';
        this.is_root = 'false';
        this.crash_time = 0;
        this.app_start_time = 0;
        this.pid = 0;
        this.uid = 0;
        this.battery = 0;
        this.is_background = false;
        this.crash_lib_uuid = undefined;
        this.cpu_usage = 0;
        this.all_thread_stacks = undefined;
        this.module_name = undefined;
        this.custom = new Object();
        this.sdk_info = new Object();
        this.plugin_info = [];
        this.crash_type = CrashType.getCrashType(l5);
        this.header = m5;
        this.filters = new NpthTags(this.header);
    }
    addFaultLogInfo(y4, z4, a5) {
        this.crash_time = a5.timestamp;
        this.app_start_time = a5.timestamp;
        this.pid = a5.pid;
        this.uid = a5.uid;
        this.filters.module = a5.module;
        let b5 = Folder.getCrashDir(y4, z4, `${a5.timestamp}`);
        try {
            if (a5.type == faultLogger.FaultType.JS_CRASH) {
                this.filters.reason = a5.reason;
                this.reason = this.filters.reason;
                this.summary = a5.summary;
                let k5 = new JsCrash(a5.summary);
                this.data = k5.toJsonString();
                if (this.reason === undefined || this.reason === null || this.reason === '') {
                    if (k5.error_message.includes('OutOfMemory')) {
                        this.reason = 'OutOfMemory';
                        this.filters.reason = 'OutOfMemory';
                    }
                }
                this.process_name = y4.applicationInfo.process;
            }
            else if (a5.type == faultLogger.FaultType.CPP_CRASH) {
                let h5 = new Tombstone(b5);
                h5.rebuildTombstone(a5);
                this.data = h5.getBacktrace();
                let i5 = h5.getSignal();
                let j5 = h5.getThreadName();
                this.reason = i5;
                this.crash_thread_name = j5;
                this.filters.reason = i5;
                this.filters.crash_thread_name = j5;
                this.process_name = h5.getProcessName();
                this.crash_lib_uuid = h5.getCrashLib();
            }
            else if (a5.type == faultLogger.FaultType.APP_FREEZE) {
                this.filters.reason = a5.reason;
                this.reason = this.filters.reason;
                AppFreeze.parse(a5, this);
            }
            else {
                this.filters.reason = a5.reason;
                this.reason = this.filters.reason;
                this.data = a5.summary;
            }
        }
        catch (g5) {
        }
        this.module = a5.module;
        this.module_name = a5.module;
        try {
            this.filters.is_64_runtime = process.is64Bit() ? 'true' : 'false';
            this.filters.is_64_device = deviceInfo.abiList.indexOf("64") > 0 ? 'true' : 'false';
        }
        catch (f5) {
        }
        try {
            this.storage = new Storage();
        }
        catch (e5) {
        }
        try {
            let d5 = b5 + '/FaultLog.txt';
            FileUtils.write(a5.fullLog, d5);
        }
        catch (c5) {
        }
    }
}
export default Body;

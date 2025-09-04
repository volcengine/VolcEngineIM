import AllThread from './AllThread';
import StringUtils from '../utils/StringUtils';
import HashMap from "@ohos.util.HashMap";
import { CrashLib } from './CrashLib';
export default class AppFreeze {
    static parse(t4, u4) {
        try {
            let w4 = StringUtils.getStringBetween(t4.fullLog, `Tid:${t4.pid},`, "PeerBinder", true);
            let x4 = StringUtils.splitString(w4, "Tid:");
            if (x4.length > 0) {
                u4.data = x4[0];
            }
            else {
                u4.data = 'Failed to parse json stack info.';
            }
            u4.all_thread_stacks = new AllThread(x4);
            u4.crash_lib_uuid = AppFreeze.crashLibParser(w4);
        }
        catch (v4) {
        }
        u4.crash_thread_name = 'main';
        if (t4.fullLog.indexOf('catcher cmd: hilog') > 0) {
            u4.logcat = StringUtils.getStringBetween(t4.fullLog, 'catcher cmd: hilog', 'Catcher log total time').split('\n').slice(1);
        }
        u4.anr_info = StringUtils.getStringBetween(t4.fullLog, "-------------------------------[cpuusage]", "catcher cmd: hidumper --mem", true);
    }
    static crashLibParser(e4) {
        let f4 = new HashMap();
        let g4 = e4.split('\n');
        g4.forEach((m4) => {
            try {
                if (m4.startsWith('#')) {
                    let o4 = m4.split('(');
                    if (o4.length >= 2) {
                        let p4 = o4[0].lastIndexOf('/');
                        if (p4 > 0 && p4 + 1 < o4[0].length) {
                            let q4 = o4[0].substring(p4 + 1);
                            if (!f4.hasKey(q4)) {
                                let r4 = o4[o4.length - 1];
                                if (!r4.includes('+')) {
                                    let s4 = r4.match('[a-f0-9]+');
                                    if (s4 != null && s4.length == 1) {
                                        f4.set(q4, s4[0]);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (n4) {
            }
        });
        let h4 = [];
        f4.forEach((k4, l4) => {
            h4.push(new CrashLib(l4, k4));
        });
        return h4;
    }
}

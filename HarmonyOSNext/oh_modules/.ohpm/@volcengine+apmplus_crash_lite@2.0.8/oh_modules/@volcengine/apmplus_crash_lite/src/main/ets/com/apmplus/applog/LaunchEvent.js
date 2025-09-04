import systemDateTime from '@ohos.systemDateTime';
import util from '@ohos.util';
import { DeviceInfo } from '../../bytedance/hpem/util/DeviceInfo';
import { AppInfo } from '../../bytedance/hpem/util/AppInfo';
import { MonitorCrash } from '../lite/crash/MonitorCrash';
const PATH = '/monitor/collect/c/session?device_platform=harmony&iid=iid';
export default class LaunchEvent {
    static reportLaunchEvent(g1) {
        let h1 = g1.getConfig();
        let i1 = new Body(h1, g1.getDeviceId());
        let j1 = getSessionUrl(h1);
        let k1 = new Object();
        k1['Content-Type'] = 'application/json; charset=utf-8';
        k1['os'] = 'Harmony';
        k1['aid'] = h1.aid;
        k1['x-auth-token'] = h1.token;
        k1['device_id'] = g1.getDeviceId();
        g1.getNetworkClient().post(j1, JSON.stringify(i1), k1, (m1, n1) => {
        });
    }
}
function getSessionUrl(e1) {
    let f1 = e1.versionCode > 0 ? e1.versionCode : AppInfo.version_code;
    return `${e1.url}${PATH}&aid=${e1.aid}&version_code=${f1}`;
}
class Body {
    constructor(c1, d1) {
        this.magic_tag = "ss_app_log";
        this.local_time = systemDateTime.getTime();
        this.launch = [new Launch()];
        this.header = new Header(c1, d1);
    }
}
class Header {
    constructor(a1, b1) {
        this.os = DeviceInfo.os;
        this.platform = DeviceInfo.os;
        this.os_version = DeviceInfo.os_version;
        this.os_api = DeviceInfo.os_api;
        this.device_model = DeviceInfo.brand_model;
        this.brand = DeviceInfo.brand;
        this.device_manufacturer = DeviceInfo.manufacture;
        this.app_version = AppInfo.app_version;
        this.version_code = AppInfo.version_code;
        this.update_version_code = AppInfo.version_code;
        this.bd_did = undefined;
        this.package = AppInfo.package;
        this.display_name = AppInfo.getDisplayName(MonitorCrash.sContext);
        this.use_apm_sdk = '1';
        this.custom = undefined;
        this.sdk_version = a1.versionCode;
        this.sdk_version_code = a1.versionCode;
        this.sdk_version_name = a1.versionName;
        this.aid = a1.aid;
        this.channel = a1.channel;
        if (a1.versionName !== undefined) {
            this.app_version = a1.versionName;
        }
        if (a1.versionCode > 0) {
            this.version_code = a1.versionCode;
            this.update_version_code = a1.versionCode;
        }
        this.bd_did = b1;
        this.addCustom(a1);
    }
    addCustom(y) {
        let z = new Object();
        z['sdk_version'] = y.versionName;
        z['host_app_id'] = y.hostAppId;
        this.custom = z;
    }
}
class Launch {
    constructor() {
        this.local_time_ms = systemDateTime.getTime();
        this.session_id = util.generateRandomUUID(false);
        this.datetime = this.getTime();
    }
    getTime() {
        let x = new Date();
        return `${x.getFullYear()}-${x.getMonth()}-${x.getDay()} ${x.getHours()}:${x.getMinutes()}:${x.getSeconds()}`;
    }
}

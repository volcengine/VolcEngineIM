import HashMap from '@ohos.util.HashMap';
import { Settings as SettingsHelper } from '../../../bytedance/hpem/setting/Settings';
import { SettingParam } from '../../../bytedance/hpem/setting/net/SettingParam';
import { DeviceInfo } from '../../../bytedance/hpem/util/DeviceInfo';
export class Settings {
    static async init(y9, z9) {
        let a10 = z9.appId;
        let b10 = '';
        b10 = z9.token;
        let c10 = getSettingsUrl(z9.host);
        let d10 = new SettingParam();
        d10.channel = z9.channel;
        d10.app_version = z9.versionName;
        d10.update_version_code = z9.versionCode.toString();
        d10.os_version = DeviceInfo.os_version;
        d10.device_model = DeviceInfo.brand_model;
        d10.user_id = z9.userId;
        d10.device_id = z9.deviceId;
        let e10 = new SettingsHelper(a10, b10, c10, d10, y9);
        e10.registerListener({
            onRefresh(f10, g10) {
                Settings.parse(a10, f10);
            },
            onReady() {
            }
        });
    }
    static parse(s9, t9) {
        try {
            let v9 = JSON.parse(t9);
            let w9 = v9['data'][0];
            let x9 = w9[s9];
            if (x9 !== undefined) {
                Settings.settings.set(s9, x9);
            }
        }
        catch (u9) {
        }
    }
    static interval(q9) {
        let r9 = Settings.settings.get(q9);
        if (r9 === undefined || r9.over_all === undefined) {
            return -1;
        }
        return r9.over_all.get_settings_interval;
    }
    static isEnable(o9) {
        let p9 = Settings.settings.get(o9);
        if (p9 === undefined) {
            return true;
        }
        return p9.status == 0;
    }
    static isCrashEnable(m9) {
        let n9 = Settings.settings.get(m9);
        if (n9 === undefined || n9.crash_module === undefined) {
            return true;
        }
        return n9.status == 0 && n9.crash_module?.switcher == 1;
    }
}
Settings.settings = new HashMap();
const PATH = '/settings/get';
function getSettingsUrl(l9) {
    return `${l9}${PATH}`;
}
class Setting {
    constructor() {
        this.status = 0;
        this.crash_module = undefined;
        this.over_all = undefined;
    }
}
class BaseModule {
    constructor() {
        this.switcher = 0;
    }
}
export class CrashModule extends BaseModule {
}
class OverAll {
    constructor() {
        this.get_settings_interval = 1000 * 60 * 60 * 24;
    }
}

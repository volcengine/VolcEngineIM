import systemDateTime from '@ohos.systemDateTime';
import * as CrashType from './CrashType';
import BuildProfile from '../../../../../../../../BuildProfile';
import display from '@ohos.display';
import { AppInfo } from '../../../../bytedance/hpem/util/AppInfo';
import { DeviceInfo } from '../../../../bytedance/hpem/util/DeviceInfo';
import { MonitorCrash } from '../MonitorCrash';
export default class Header {
    constructor() {
        this.access = '';
        this.aid = '';
        this.app_version = AppInfo.app_version;
        this.channel = '';
        this.cpu_abi = DeviceInfo.cpu_abi;
        this.cpu_model = '';
        this.crash_type = '';
        this.density_dpi = 0;
        this.resolution = '';
        this.device_brand = DeviceInfo.brand;
        this.device_id = '';
        this.device_manufacturer = DeviceInfo.manufacture;
        this.device_model = DeviceInfo.brand_model;
        this.display_name = '';
        this.app_name = AppInfo.display_name;
        this.first_update_launch = 0;
        this.hardware = DeviceInfo.hardware;
        this.kernel_version = '';
        this.manifest_version_code = 0;
        this.origin_device_model = DeviceInfo.device_model;
        this.os = DeviceInfo.os;
        this.os_api = DeviceInfo.os_api;
        this.os_version = DeviceInfo.os_version;
        this.package = AppInfo.package;
        this.query_update_version_code = '';
        this.release_build = '';
        this.report_region = '';
        this.rom = DeviceInfo.rom;
        this.rom_version = DeviceInfo.rom_version;
        this.sdk_version = this.getVersionCode();
        this.sdk_version_name = BuildProfile.HAR_VERSION;
        this.timezone = '';
        this.unique_key = '';
        this.update_version_code = AppInfo.version_code;
        this.user_id = '';
        this.verify_info = '';
        this.version_code = AppInfo.version_code;
        this.version_get_time = 0;
        this.custom = new Object();
        this.host_app_id = '';
        this.addDisplayInfo();
        try {
            this.display_name = AppInfo.getDisplayName(MonitorCrash.sContext);
        }
        catch (f6) {
        }
    }
    addDisplayInfo() {
        try {
            let e6 = display.getDefaultDisplaySync();
            this.resolution = `${e6.height}x${e6.width}`;
            this.density_dpi = e6.densityDPI;
        }
        catch (d6) {
        }
    }
    static currentHeader(z5, a6, b6) {
        let c6 = new Header();
        c6.crash_type = CrashType.getCrashType(z5);
        c6.update(a6, b6);
        return c6;
    }
    update(v5, w5) {
        try {
            this.aid = w5.appId;
            this.device_id = w5.deviceId;
            this.unique_key = this.crash_type + '_' + v5 + '_' + this.aid + '_' + this.device_id;
            this.channel = w5.channel;
            this.user_id = w5.userId;
            this.timezone = systemDateTime.getTimezoneSync();
        }
        catch (y5) {
        }
        try {
            if (w5.versionCode > 0) {
                this.update_version_code = w5.versionCode;
            }
            else {
                this.update_version_code = this.version_code;
            }
            if (w5.versionName !== undefined && w5.versionName !== '') {
                this.app_version = w5.versionName;
            }
        }
        catch (x5) {
        }
    }
    getVersionCode() {
        try {
            let t5 = BuildProfile.HAR_VERSION;
            let u5 = t5.split('.');
            return Number.parseInt(u5[0] + u5[1] + u5[2]);
        }
        catch (s5) {
        }
        return 0;
    }
}

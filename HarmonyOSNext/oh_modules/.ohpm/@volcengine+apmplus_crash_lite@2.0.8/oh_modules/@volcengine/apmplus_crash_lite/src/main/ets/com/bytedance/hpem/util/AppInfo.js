import bundleManager from "@ohos.bundle.bundleManager";
export class AppInfo {
    static get app_version() {
        if (AppInfo._app_version === '') {
            AppInfo.updateAppInfo();
        }
        return AppInfo._app_version;
    }
    static get display_name() {
        if (AppInfo._display_name === '') {
            AppInfo.updateAppInfo();
        }
        return AppInfo._display_name;
    }
    static get package() {
        if (AppInfo._package === '') {
            AppInfo.updateAppInfo();
        }
        return AppInfo._package;
    }
    static get version_code() {
        if (AppInfo._version_code === 0) {
            AppInfo.updateAppInfo();
        }
        return AppInfo._version_code;
    }
    static get install_time() {
        if (AppInfo._install_time === 0) {
            AppInfo.updateAppInfo();
        }
        return AppInfo._install_time;
    }
    static get update_time() {
        if (AppInfo._update_time === 0) {
            AppInfo.updateAppInfo();
        }
        return AppInfo._update_time;
    }
    static updateAppInfo() {
        let d16 = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
        AppInfo._display_name = d16.appInfo.name;
        AppInfo._version_code = d16.versionCode;
        AppInfo._app_version = d16.versionName;
        AppInfo._package = d16.name;
        AppInfo._install_time = d16.installTime;
        AppInfo._update_time = d16.updateTime;
    }
    static getDisplayName(c16) {
        return c16.resourceManager.getStringSync(c16.applicationInfo.labelResource.id);
    }
}
AppInfo._app_version = '';
AppInfo._display_name = '';
AppInfo._package = '';
AppInfo._version_code = 0;
AppInfo._install_time = 0;
AppInfo._update_time = 0;
export default AppInfo;

export declare class AppInfo {
    private static _app_version;
    static get app_version(): string;
    private static _display_name;
    static get display_name(): string;
    private static _package;
    static get package(): string;
    private static _version_code;
    static get version_code(): number;
    private static _install_time;
    static get install_time(): number;
    private static _update_time;
    static get update_time(): number;
    private static updateAppInfo;
    static getDisplayName(c16: Context): string;
}
export default AppInfo;

import faultLogger from '@ohos.faultLogger';
import { Config } from '../Config';
/**
 * @madewei
 * @date 2023/11/17
 */
export default class Header {
    access: string;
    aid: string;
    app_version: string;
    channel: string;
    cpu_abi: string;
    cpu_model: string;
    crash_type: string;
    density_dpi: number;
    resolution: string;
    device_brand: string;
    device_id: string;
    device_manufacturer: string;
    device_model: string;
    display_name: string;
    app_name: string;
    first_update_launch: number;
    hardware: string;
    kernel_version: string;
    manifest_version_code: number;
    origin_device_model: string;
    os: string;
    os_api: number;
    os_version: string;
    package: string;
    query_update_version_code: string;
    release_build: string;
    report_region: string;
    rom: string;
    rom_version: string;
    sdk_version: number;
    sdk_version_name: string;
    timezone: string;
    unique_key: string;
    update_version_code: number;
    user_id: string;
    verify_info: string;
    version_code: number;
    version_get_time: number;
    custom: object;
    host_app_id: string;
    constructor();
    private addDisplayInfo;
    /**
     * 当前状态下的Header
     * @param crashType
     * @param crashTime
     * @returns
     */
    static currentHeader(z5: faultLogger.FaultType, a6: number, b6: Config): Header;
    private update;
    private getVersionCode;
}

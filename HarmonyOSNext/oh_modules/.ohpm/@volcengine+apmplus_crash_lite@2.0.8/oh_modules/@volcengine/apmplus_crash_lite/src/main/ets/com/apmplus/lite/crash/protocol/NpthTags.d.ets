import Header from './Header';
/**
 * @madewei
 * @date 2023/11/17
 */
export declare class NpthTags {
    app_version: string;
    channel: string;
    cpu_abi: string;
    device_brand: string;
    device_manufacturer: string;
    device_model: string;
    hardware: string;
    os_api: number;
    rom_version: string;
    sdk_version_name: string;
    update_version_code: number;
    reason: string;
    module: string;
    crash_thread_name: string;
    is_root: string;
    is_background: boolean;
    is_64_device: string;
    is_64_runtime: string;
    is_isolated_process: boolean;
    constructor(q6: Header);
}

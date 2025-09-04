export class NpthTags {
    constructor(q6) {
        this.app_version = '';
        this.channel = '';
        this.cpu_abi = '';
        this.device_brand = '';
        this.device_manufacturer = '';
        this.device_model = '';
        this.hardware = '';
        this.os_api = 0;
        this.rom_version = '';
        this.sdk_version_name = '';
        this.update_version_code = 0;
        this.reason = '';
        this.module = '';
        this.crash_thread_name = '';
        this.is_root = 'false';
        this.is_background = false;
        this.is_64_device = 'true';
        this.is_64_runtime = 'true';
        this.is_isolated_process = false;
        this.app_version = q6.app_version;
        this.channel = q6.channel;
        this.cpu_abi = q6.cpu_abi;
        this.device_brand = q6.device_brand;
        this.device_manufacturer = q6.device_manufacturer;
        this.device_model = q6.device_model;
        this.hardware = q6.hardware;
        this.rom_version = q6.rom_version;
        this.sdk_version_name = q6.sdk_version_name;
        this.os_api = q6.os_api;
        this.update_version_code = q6.update_version_code;
    }
}

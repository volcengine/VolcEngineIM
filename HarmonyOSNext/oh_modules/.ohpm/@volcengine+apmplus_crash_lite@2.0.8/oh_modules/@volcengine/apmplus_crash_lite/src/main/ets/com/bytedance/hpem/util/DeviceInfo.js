import deviceInfo from "@ohos.deviceInfo";
export class DeviceInfo {
    static get os() {
        return DeviceInfo._os;
    }
    static get rom_version() {
        return DeviceInfo._rom_version;
    }
    static get rom() {
        return DeviceInfo._rom;
    }
    static get cpu_abi() {
        return DeviceInfo._cpu_abi;
    }
    static get brand() {
        return DeviceInfo._brand;
    }
    static get os_api() {
        return DeviceInfo._os_api;
    }
    static get manufacture() {
        return DeviceInfo._manufacture;
    }
    static get device_model() {
        return DeviceInfo._device_model;
    }
    static get brand_model() {
        return DeviceInfo._brand_model;
    }
    static get os_version() {
        return DeviceInfo._os_version;
    }
    static get hardware() {
        return DeviceInfo._hardware;
    }
}
DeviceInfo._os_version = deviceInfo.majorVersion + '.' + deviceInfo.seniorVersion + '.' + deviceInfo.featureVersion;
DeviceInfo._os = 'harmony';
DeviceInfo._rom_version = deviceInfo.displayVersion;
DeviceInfo._rom = deviceInfo.osFullName;
DeviceInfo._cpu_abi = deviceInfo.abiList;
DeviceInfo._brand = deviceInfo.brand;
DeviceInfo._os_api = deviceInfo.sdkApiVersion;
DeviceInfo._manufacture = deviceInfo.manufacture;
DeviceInfo._device_model = deviceInfo.productModel;
DeviceInfo._brand_model = deviceInfo.brand + ' ' + deviceInfo.productModel;
DeviceInfo._hardware = deviceInfo.hardwareModel;
export default DeviceInfo;

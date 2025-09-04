import { Settings } from './Settings';
import { AppLog } from '../../applog/AppLog';
import { InitConfig } from '../../applog/InitConfig';
import Folder from './Folder';
import Uploader from './Uploader';
export class MonitorCrash {
    constructor(w3, x3) {
        this._appLog = undefined;
        this._context = w3.getApplicationContext();
        this._config = x3;
        MonitorCrash.sContext = this._context;
        if (x3.autoStart) {
            this.start();
        }
    }
    static init(t3, u3) {
        let v3 = new MonitorCrash(t3, u3);
        return v3;
    }
    start() {
        Folder.initHomeDir(this._context, this.config.appId);
        if (this.config.deviceId === undefined || this.config.deviceId === '') {
            this.config.deviceId = AppLog.getSavedDeviceId(this._context, this.config.appId);
        }
        Settings.init(this._context, this.config);
        if (Settings.isEnable(this.config.appId)) {
            this._appLog = this.initAppLog();
            if (!this._config.customPageView) {
                this._appLog.onLaunchEvent();
            }
            if (Settings.isCrashEnable(this.config.appId)) {
                Uploader.start(this._context, this.config);
            }
        }
    }
    get config() {
        return this._config;
    }
    lunchEvent() {
        this._appLog?.onLaunchEvent();
    }
    initAppLog() {
        let r3 = new InitConfig(this.config.appId, this.config.token, this.config.channel);
        r3.versionCode = this.config.versionCode;
        r3.versionName = this._config.versionName;
        r3.hostAppId = this._config.hostAppId;
        r3.deviceId = this._config.deviceId;
        r3.url = this._config.host;
        let s3 = AppLog.init(this._context, r3, this._config.networkClient);
        return s3;
    }
}

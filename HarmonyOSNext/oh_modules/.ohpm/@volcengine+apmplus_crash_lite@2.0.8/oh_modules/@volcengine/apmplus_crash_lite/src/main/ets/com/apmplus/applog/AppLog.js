import HashMap from '@ohos.util.HashMap';
import LaunchEvent from './LaunchEvent';
import { KVStorage } from './storage/KVStorage';
import systemDateTime from "@ohos.systemDateTime";
export class AppLog {
    constructor(m, n, o) {
        this.savedDeviceId = undefined;
        this.config = n;
        this.context = m;
        this.networkClient = o;
    }
    static init(h, i, j) {
        let k = AppLog.getInstance(i.aid);
        if (k !== undefined) {
            return k;
        }
        k = new AppLog(h, i, j);
        let l = i.aid + KVStorage.KEY_DEVICE_ID;
        if (i.deviceId !== undefined && i.deviceId !== null) {
            KVStorage.getPreferences(h)?.putSync(l, i.deviceId);
        }
        AppLog.instances.set(i.aid, k);
        return k;
    }
    static getInstance(g) {
        return AppLog.instances.get(g);
    }
    setNetworkNetClient(f) {
        this.networkClient = f;
    }
    onLaunchEvent() {
        LaunchEvent.reportLaunchEvent(this);
    }
    getNetworkClient() {
        return this.networkClient;
    }
    getContent() {
        return this.context;
    }
    getConfig() {
        return this.config;
    }
    getDeviceId() {
        if (this.savedDeviceId === undefined) {
            this.savedDeviceId = AppLog.getSavedDeviceId(this.context, this.config.aid);
        }
        return this.savedDeviceId;
    }
    static getSavedDeviceId(a, b) {
        let c = b + KVStorage.KEY_DEVICE_ID;
        let d = KVStorage.getPreferences(a);
        let e = d.getSync(c, undefined);
        if (e === undefined || e === '') {
            e = systemDateTime.getTime(true).toString();
            d.putSync(c, e);
            d.flush();
        }
        return e;
    }
}
AppLog.instances = new HashMap();

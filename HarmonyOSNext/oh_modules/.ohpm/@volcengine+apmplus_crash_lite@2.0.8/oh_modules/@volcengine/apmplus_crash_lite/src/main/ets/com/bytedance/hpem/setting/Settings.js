import { NetworkClient } from '../net/NetworkClient';
import { HpemLog } from '../util/HpemLog';
import ArrayList from "@ohos.util.ArrayList";
import http from '@ohos.net.http';
import { SettingStorage } from './SettingStorage';
export class Settings {
    constructor(r15, s15, t15, u15, v15) {
        this.aid = '';
        this.token = '';
        this.url = '';
        this.intervalId = 0;
        this.interval = 1000 * 60 * 60;
        this.storage = undefined;
        this.currentSetting = '';
        this.list = new ArrayList();
        this.ready = false;
        this.settingFromLocal = false;
        this.hasInterval = false;
        this.aid = r15;
        this.token = s15;
        this.url = t15;
        this.commonParam = u15;
        this.storage = new SettingStorage(r15, v15);
        this.updateFromLocal();
        this.beginUpdate();
    }
    beginUpdate() {
        if (!this.hasInterval) {
            this.hasInterval = true;
            this.requestSetting();
            this.startInterval();
        }
    }
    startInterval() {
        this.intervalId = setInterval(() => {
            this.requestSetting();
        }, this.interval);
    }
    requestSetting() {
        try {
            HpemLog.debug(Settings.TAG, 'setting request begin url:' + this.url + " aid:" + this.aid);
            let l15 = new Object();
            l15['Content-Type'] = 'application/json; charset=utf8';
            if (this.token !== null && this.token !== undefined && this.token.trim() !== "") {
                l15['aid'] = this.aid;
                l15['x-auth-token'] = this.token;
            }
            NetworkClient.getNetworkClient()
                .post(this.url, JSON.stringify(this.getBody()), l15, (n15, o15) => {
                if (o15 != null && o15.responseCode == http.ResponseCode.OK) {
                    let p15 = o15.result;
                    if (typeof p15 === 'string') {
                        this.updateCurrentSetting(p15, false);
                        this.saveToLocal(p15);
                        this.notifyListener(p15);
                    }
                    else {
                        HpemLog.debug(Settings.TAG, 'setting request false :' + p15);
                    }
                }
            });
        }
        catch (k15) {
            HpemLog.error('setting request failed', k15);
        }
    }
    getBody() {
        let i15 = new Array();
        let j15 = new Object;
        j15['channel'] = this.commonParam.channel;
        j15['app_version'] = this.commonParam.app_version;
        j15['update_version_code'] = this.commonParam.update_version_code;
        j15['os_version'] = this.commonParam.os_version;
        j15['device_model'] = this.commonParam.device_model;
        j15['user_id'] = this.commonParam.user_id;
        j15['device_id'] = this.commonParam.device_id;
        j15['os'] = 'harmony';
        j15['aid'] = this.aid;
        if (this.token !== null && this.token !== undefined && this.token.trim() !== "") {
            j15['x-auth-token'] = this.token;
        }
        i15.push(j15);
        return i15;
    }
    updateFromLocal() {
        if (this.storage != undefined) {
            let h15 = this.storage.getSetting();
            this.updateCurrentSetting(h15, true);
            this.notifyListener(h15);
        }
    }
    saveToLocal(g15) {
        if (this.storage != undefined) {
            this.storage.saveSetting(g15);
        }
    }
    updateCurrentSetting(e15, f15) {
        this.currentSetting = e15;
        this.settingFromLocal = f15;
    }
    notifyListener(b15) {
        if (b15 == null || b15 == undefined || b15.trim() == "") {
            return;
        }
        for (let d15 of this.list) {
            d15.onRefresh(b15, this.settingFromLocal);
        }
        if (!this.ready) {
            this.ready = true;
            for (let c15 of this.list) {
                c15.onReady();
            }
        }
    }
    setUpdateInterval(a15) {
        if (a15 > Settings.minInterval && a15 != this.interval) {
            this.interval = a15;
            this.stopUpdate();
            this.startInterval();
        }
    }
    registerListener(z14) {
        if (z14 == null)
            return;
        if (!this.list.has(z14)) {
            this.list.add(z14);
        }
        if (this.ready) {
            z14.onRefresh(this.currentSetting, this.settingFromLocal);
            z14.onReady();
        }
    }
    removeListener(y14) {
        if (y14 == null)
            return;
        this.list.remove(y14);
    }
    stopUpdate() {
        if (this.intervalId) {
            clearInterval(this.intervalId);
            this.intervalId = 0;
        }
    }
}
Settings.TAG = "Settings";
Settings.minInterval = 1000 * 60;

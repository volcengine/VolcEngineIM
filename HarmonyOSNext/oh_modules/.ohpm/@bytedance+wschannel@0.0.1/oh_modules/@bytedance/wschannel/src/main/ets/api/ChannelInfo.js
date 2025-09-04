import List from "@ohos.util.List";
import { Md5 } from '../utils/md5';
export class ChannelInfo {
    constructor(a1, b1, c1, d1, e1, f1, g1, h1, i1, j1) {
        this.extra = new Map();
        this.headers = new Map();
        this.urls = new List();
        this.deviceId = a1;
        this.installId = b1;
        this.fpid = c1;
        this.aid = d1;
        this.appKey = e1;
        this.appVersion = f1;
        this.updateVersionCode = g1;
        if (d1 <= 0) {
            throw new Error("aid is invalid:" + d1);
        }
        if (c1 <= 0) {
            throw new Error("fpid is invalid:" + c1);
        }
        if (a1.length == 0) {
            throw new Error("deviceId is empty.");
        }
        if (e1.length == 0) {
            throw new Error("appKey is empty.");
        }
        if (h1.isEmpty()) {
            throw new Error("urls is empty.");
        }
        for (let q1 of h1) {
            this.urls.add(q1);
        }
        i1.forEach((o1, p1) => {
            this.extra.set(p1, o1);
        });
        j1.forEach((m1, n1) => {
            this.headers.set(n1, m1);
        });
    }
    getAccessKey() {
        let z = this.fpid + this.appKey + this.deviceId + ChannelInfo.ACCESS_SALT;
        return Md5.hashStr(z);
    }
    createCommonParams() {
        let y = "aid=" + this.aid + "&fpid=" + this.fpid + "&version_code=" + this.appVersion +
            "&x_update_version=" + this.updateVersionCode + "&device_id=" + this.deviceId + "&access_key=" + this.getAccessKey();
        if (this.installId != undefined) {
            y += "&iid=" + this.installId;
        }
        return y;
    }
    getDeviceId() {
        return this.deviceId;
    }
    getInstallId() {
        return this.installId;
    }
    getFpid() {
        return this.fpid;
    }
    getAid() {
        return this.aid;
    }
    getAppKey() {
        return this.appKey;
    }
    getAppVersion() {
        return this.appVersion;
    }
    getExtraParam() {
        return this.extra;
    }
    getHeaders() {
        return this.headers;
    }
    getUrls() {
        return this.urls;
    }
}
ChannelInfo.ACCESS_SALT = "f8a69f1719916z";
export class ChannelInfoBuilder {
    constructor(t, u, v, w, x) {
        this.appVersion = 0;
        this.updateVersionCode = 0;
        this.extra = new Map();
        this.headers = new Map();
        this.urls = new List();
        this.aid = t;
        this.fpid = u;
        this.deviceId = v;
        this.appKey = w;
        this.urls = x;
    }
    setDeviceId(s) {
        this.deviceId = s;
        return this;
    }
    setInstallId(r) {
        this.installId = r;
        return this;
    }
    setFpid(q) {
        this.fpid = q;
        return this;
    }
    setAid(p) {
        this.aid = p;
        return this;
    }
    setAppKey(o) {
        this.appKey = o;
        return this;
    }
    setAppVersion(n) {
        this.appVersion = n;
        return this;
    }
    setUpdateVersionCode(m) {
        this.updateVersionCode = m;
        return this;
    }
    setUrls(k) {
        for (let l of k) {
            this.urls.add(l);
        }
        return this;
    }
    setExtraParams(g) {
        g.forEach((i, j) => {
            this.extra.set(j, i);
        });
        return this;
    }
    setHeaders(c) {
        c.forEach((e, f) => {
            this.headers.set(f, e);
        });
        return this;
    }
    header(a, b) {
        this.headers[a] = b;
        return this;
    }
    build() {
        return new ChannelInfo(this.deviceId, this.installId, this.fpid, this.aid, this.appKey, this.appVersion, this.updateVersionCode, this.urls, this.extra, this.headers);
    }
}

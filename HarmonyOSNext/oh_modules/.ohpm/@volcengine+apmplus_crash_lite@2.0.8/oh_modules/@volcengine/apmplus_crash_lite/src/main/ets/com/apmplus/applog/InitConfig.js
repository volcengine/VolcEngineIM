export class InitConfig {
    constructor(u, v, w) {
        this._deviceId = undefined;
        this._hostAppId = undefined;
        this._versionCode = -1;
        this._versionName = undefined;
        this._url = 'https://apmplus.volces.com';
        this._aid = u;
        this._token = v;
        this._channel = w;
    }
    set deviceId(t) {
        this._deviceId = t;
    }
    get aid() {
        return this._aid;
    }
    get token() {
        return this._token;
    }
    get channel() {
        return this._channel;
    }
    set hostAppId(s) {
        this._hostAppId = s;
    }
    get hostAppId() {
        return this._hostAppId;
    }
    get deviceId() {
        return this._deviceId;
    }
    get versionCode() {
        return this._versionCode;
    }
    set versionCode(r) {
        this._versionCode = r;
    }
    get versionName() {
        return this._versionName;
    }
    set versionName(q) {
        this._versionName = q;
    }
    get url() {
        return this._url;
    }
    set url(p) {
        this._url = p;
    }
}

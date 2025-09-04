import { NetworkClient } from '../../../bytedance/hpem/net/NetworkClient';
import { Logger } from './Logger';
import { AppInfo } from '../../../bytedance/hpem/util/AppInfo';
export class Config {
    constructor() {
        this._appId = '';
        this._token = undefined;
        this._channel = undefined;
        this._versionCode = AppInfo.version_code;
        this._versionName = AppInfo.app_version;
        this._packageNames = [];
        this._soList = [];
        this._deviceId = '';
        this._userId = undefined;
        this._host = 'https://apmplus.volces.com';
        this._autoStart = true;
        this._hostAppId = undefined;
        this._customPageView = false;
        this._DynamicParams = undefined;
        this._NetworkClient = undefined;
    }
    get appId() {
        return this._appId;
    }
    set appId(v2) {
        if (v2 === '') {
            throw Error('Invalid appId argument');
        }
        this._appId = v2;
    }
    get token() {
        if (this._token == undefined) {
            return '';
        }
        return this._token;
    }
    set token(u2) {
        if (u2 === '') {
            throw Error('Invalid token argument');
        }
        this._token = u2;
    }
    get channel() {
        if (this._channel == undefined) {
            return '';
        }
        return this._channel;
    }
    set channel(t2) {
        if (t2 === '') {
            throw Error('Invalid channel argument');
        }
        this._channel = t2;
    }
    get versionCode() {
        return this._versionCode;
    }
    set versionCode(s2) {
        if (s2 < 0) {
            throw Error('Invalid versionCode argument');
        }
        this._versionCode = s2;
    }
    get versionName() {
        if (this._versionName == undefined) {
            return '';
        }
        return this._versionName;
    }
    set versionName(r2) {
        this._versionName = r2;
    }
    get deviceId() {
        if (this._DynamicParams != undefined) {
            let q2 = this._DynamicParams.getDeviceId();
            if (q2 !== '') {
                return q2;
            }
        }
        return this._deviceId;
    }
    set deviceId(p2) {
        this._deviceId = p2;
    }
    get userId() {
        if (this._DynamicParams != undefined) {
            let o2 = this._DynamicParams.getUserId();
            if (o2 != '') {
                return o2;
            }
        }
        if (this._userId == undefined) {
            return '0';
        }
        return this._userId;
    }
    set userId(n2) {
        this._userId = n2;
    }
    get host() {
        if (this._host === undefined) {
            return 'https://apmplus.volces.com';
        }
        return this._host;
    }
    set host(m2) {
        if (m2 === '') {
            throw Error('Invalid url argument');
        }
        else if (!m2.startsWith('http')) {
            m2 = 'https://' + m2;
        }
        this._host = m2;
    }
    get autoStart() {
        return this._autoStart;
    }
    set autoStart(l2) {
        this._autoStart = l2;
    }
    set customPageView(k2) {
        this._customPageView = k2;
    }
    get customPageView() {
        return this._customPageView;
    }
    get dynamicParams() {
        return this._DynamicParams;
    }
    set dynamicParams(j2) {
        this._DynamicParams = j2;
    }
    get soList() {
        return this._soList;
    }
    set soList(i2) {
        this._soList = i2;
    }
    get packageNames() {
        return this._packageNames;
    }
    set packageNames(h2) {
        this._packageNames = h2;
    }
    get hostAppId() {
        if (this._hostAppId === undefined) {
            return '';
        }
        return this._hostAppId;
    }
    set hostAppId(g2) {
        this._hostAppId = g2;
    }
    get networkClient() {
        if (this._NetworkClient === undefined) {
            return NetworkClient.getNetworkClient();
        }
        return this._NetworkClient;
    }
    set networkClient(f2) {
        this._NetworkClient = f2;
    }
}
export function sdk(d2, e2) {
    return new Builder(d2, e2);
}
export class Builder {
    constructor(b2, c2) {
        this.mConfig = new Config();
        this.mConfig.appId = b2;
        this.mConfig.token = c2;
    }
    channel(a2) {
        this.mConfig.channel = a2;
        return this;
    }
    versionCode(z1) {
        this.mConfig.versionCode = z1;
        return this;
    }
    versionName(y1) {
        this.mConfig.versionName = y1;
        return this;
    }
    dynamicParams(x1) {
        this.mConfig.dynamicParams = x1;
        return this;
    }
    url(w1) {
        this.mConfig.host = w1;
        return this;
    }
    autoStart(v1) {
        this.mConfig.autoStart = v1;
        return this;
    }
    soList(u1) {
        this.mConfig.soList = u1;
        return this;
    }
    keyWords(t1) {
        this.mConfig.packageNames = t1;
        return this;
    }
    customPageView(s1) {
        this.mConfig.customPageView = s1;
        return this;
    }
    hostAppId(r1) {
        this.mConfig.hostAppId = r1;
        return this;
    }
    networkClient(q1) {
        this.mConfig.networkClient = q1;
        return this;
    }
    debug(p1) {
        Logger.LOG_ENABLE = p1;
        return this;
    }
    build() {
        return this.mConfig;
    }
}

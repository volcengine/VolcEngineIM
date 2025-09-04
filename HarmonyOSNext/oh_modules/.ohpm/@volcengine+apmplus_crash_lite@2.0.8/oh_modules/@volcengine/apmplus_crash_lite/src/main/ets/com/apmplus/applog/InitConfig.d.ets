export declare class InitConfig {
    private _aid;
    private _token;
    private _channel;
    private _deviceId;
    private _hostAppId;
    private _versionCode;
    private _versionName;
    private _url;
    constructor(u: string, v: string, w: string);
    set deviceId(t: string | undefined);
    get aid(): string;
    get token(): string;
    get channel(): string | undefined;
    set hostAppId(s: string | undefined);
    get hostAppId(): string | undefined;
    get deviceId(): string | undefined;
    get versionCode(): number;
    set versionCode(r: number);
    get versionName(): string | undefined;
    set versionName(q: string | undefined);
    get url(): string;
    set url(p: string);
}

import { Callback } from "@kit.BasicServicesKit";
export enum RequestFlagEnum {
    REQUEST_FLAG_NORMAL = 0,
    REQUEST_FLAG_BYPASS_PROXY = 128
}
export enum HttpDataTypeEnum {
    STRING,
    ARRAY_BUFFER
}
export interface CronetHeader {
    name: string;
    value: string;
}
export interface HttpRequestOptions {
    method?: string;
    header?: Array<CronetHeader>;
    extraData?: string | ArrayBuffer;
    expectDataType?: HttpDataTypeEnum;
    priority?: number;
    requestTimeout?: number;
    readTimeout?: number;
    connectTimeout?: number;
    writeTimeout?: number;
    loadFlags?: number;
}
export interface TTHttpResponse {
    url: string;
    urlChain: Array<string>;
    httpStatusCode: number;
    httpStatusText: string;
    header: Array<CronetHeader>;
    wasCached: boolean;
    protocol: string;
    proxyServer: string;
    receivedByteCount: number;
}
export interface CronetError {
    errorCode: number;
    message: string;
    internalErrorCode: number;
    immediatelyRetryable: boolean;
    quicDetailedErrorCode: number;
}
export interface RedirectInfo {
    responseInfo: TTHttpResponse;
    newLocationUrl: string;
}
export interface ErrorInfo {
    error: CronetError;
    requestLog: string;
}
export class TTHttpRequest {
    setEngine(n2: TTCronetEngine): void;
    start(l2: string, m2: HttpRequestOptions): number;
    cancel(): void;
    followRedirect(): void;
    writeMore(j2: string | ArrayBuffer, k2: boolean): void;
    destroy();
    removeRequestCookieHeader(): void;
    addRequestCookieHeader(h2: string, i2: string): void;
    setOnRedirectCallback(g2: Callback<RedirectInfo>): void;
    setOnResponseStartCallback(f2: Callback<TTHttpResponse>): void;
    setOnReadCompleteCallback(e2: Callback<string | ArrayBuffer>): void;
    setOnSuccessCallback(d2: (requestLog: string, body?: string | ArrayBuffer) => void): void;
    setOnFailCallback(c2: Callback<ErrorInfo>): void;
    setOnCancelCallback(b2: Callback<string>): void;
    // 流式上传需要设置该callback
    setReadCallback(a2: Callback<void>): void;
}
export interface TTAppInfo {
    appId?: string;
    appName?: string;
    deviceId?: string;
    versionCode?: string;
    deviceType?: string;
    channel?: string;
    devicePlatform?: string;
    updateVersionCode?: string;
    tncHostFirst?: string;
    tncHostSecond?: string;
    tncHostThird?: string;
    isMainProcess?: string;
    isDropFirstTnc?: string;
    domainHttpDns?: string;
    domainNetlog?: string;
    domainBoe?: string;
    getDomainDefaultJson?: string;
    tncHeaders?: Object;
    tncQueries?: Object;
    tncLoadFlags?: number;
    httpdnsLoadFlags?: number;
    mIsDomestic?: number;
}
export interface QuicHint {
    host: string;
    port: number;
    alternatePort: number;
}
export interface EngineParams {
    userAgent?: string;
    acceptLanguage?: string;
    storagePath?: string;
    storeIdcRuleJson?: string;
    enableQuic?: boolean;
    enableHttp2?: boolean;
    enableBrotli?: boolean;
    quicHints?: Array<QuicHint>;
    experimentalOptions?: string;
    enableNetworkQualityEstimator?: boolean;
    proxyConfig?: string;
    opaqueData?: Array<number[]>;
    // std::vector<Cronet_ClientOpaqueData> client_opaque_data_store;
    enableVerboseLog?: boolean;
    appInfo?: TTAppInfo;
}
export interface TTDispatchResult {
    originalUrl: string;
    finalUrl: string;
    epoch: string;
    etag: string;
}
// just for testing
export interface TTSecurityInfo {
    url: string;
    header: Array<CronetHeader>;
}
export class TTCronetEngine {
    start(z1: EngineParams): number;
    getErrorString(y1: number): string;
    setProxy(x1: string): void;
    triggerGetDomain(w1?: TTAppInfo): void;
    urlDispatch(v1: string): Promise<TTDispatchResult>;
    setTNCConfigUpdatedCallback(u1: Callback<string>): void;
    setOpaque(r1: number, s1: number, t1: number);
    // just for testing
    setSecurityCallbackForTesting(q1: Callback<TTSecurityInfo>);
}
export class TTNetworkChangeNotifier {
    notifyTypeChanged(o1: string, p1: number): void;
    notifyConnected(l1: number, m1: string, n1: boolean): void;
    notifyDisconnected(j1: number, k1: boolean): void;
    notifyConnectionOnInit(g1: string, h1: number, i1: boolean): void;
    notifyVPNChanged(f1: boolean): void;
    notifyProxyChanged(e1: string): void;
}
// ======================================  websocket ===========================================
export enum WSClientConnectionModeEnum {
    CONNECTION_FRONTIER = 0,
    CONNECTION_WSCHANNEL
}
export interface WSClientConnectionParams {
    urls?: Array<string>;
    appKey?: string;
    appId?: number;
    deviceId?: number;
    fpid?: number;
    sdkVersion?: number;
    appVersion?: number;
    installId?: number;
    sessionId?: string;
    webId?: number;
    platform?: number;
    network?: number;
    appToken?: string;
    appStateReportEnabled?: boolean;
    customParams?: object;
    customHeaders?: object;
    sharedConnection?: boolean;
    mode?: WSClientConnectionModeEnum;
    timeout?: number;
    ignoreOfflineState?: boolean;
    load_flags?: RequestFlagEnum;
}
export enum WSClientModeEnum {
    STOP,
    RUN,
    RUN_AND_KEEP_ALIVE
}
export enum ConnectionStateEnum {
    CONNECT_UNKNOWN = -1,
    CONNECTING,
    DISCONNECTING,
    CONNECT_FAILED,
    CONNECT_CLOSED,
    CONNECTED
}
export interface ConnectionStateChangedInfo {
    state: ConnectionStateEnum;
    url: string;
}
export interface ConnectionErrorInfo {
    state: ConnectionStateEnum;
    url: string;
    error: string;
}
export interface TrafficChangedInfo {
    url: string;
    sent_bytes: number;
    received_bytes: number;
}
export class TTWebsocketClient {
    setEngine(d1: TTCronetEngine): void;
    configConnection(c1: WSClientConnectionParams);
    setupMode(b1: WSClientModeEnum);
    startConnection();
    stopConnection();
    isConnected(): boolean;
    send(a1: string | ArrayBuffer): void;
    destroy(): void;
    setOnConnectionStateChangedCallback(z: Callback<ConnectionStateChangedInfo>): void;
    setOnConnectionErrorCallback(y: Callback<ConnectionErrorInfo>);
    setOnMessageReceivedCallback(x: Callback<ArrayBuffer>);
    setOnFeedbackLogCallback(w: Callback<string>);
    setOnTrafficChangedCallback(v: Callback<TrafficChangedInfo>);
}

import List from '@ohos.util.List';
export interface IWsChannelClient {
    initClient(): any;
    isConnected(): boolean;
    openConnection(config: WsConnectionConfig): Promise<boolean>;
    onParameterChange(config: WsConnectionConfig): Promise<boolean>;
    stopConnection(): Promise<boolean>;
    sendMessage(data: ArrayBuffer | string): Promise<boolean>;
    destroy(): void;
}
export declare enum ConnectionState {
    CONNECTION_UNKNOWN = 1,
    CONNECTING = 2,
    CONNECT_FAILED = 4,
    CONNECT_CLOSED = 8,
    CONNECTED = 16,
    DISCONNECTING = 32
}
export declare abstract class WsCallback {
    abstract onBinaryMessage(n12: ArrayBuffer): any;
    abstract onTextMessage(m12: string): any;
    abstract onConnectionStateChanged(j12: string, k12: ConnectionState, l12: string): any;
    abstract onConnectionError(h12: string, i12: string): any;
}
export declare class WsConnectionConfig {
    private urls;
    private commonParams;
    private headerMap;
    private queryMap;
    private pingInterval;
    constructor(i5: List<string>, j5: string);
    addHeaderMap(h5: Map<string, string>): void;
    addQueryMap(g5: Map<string, string>): void;
    addPingInterval(f5: number): void;
    getPingInterval(): number;
    getUrls(): List<string>;
    getCommonParams(): string;
    getHeaderMap(): Map<string, string> | null;
    getQueryMap(): Map<string, string> | null;
}

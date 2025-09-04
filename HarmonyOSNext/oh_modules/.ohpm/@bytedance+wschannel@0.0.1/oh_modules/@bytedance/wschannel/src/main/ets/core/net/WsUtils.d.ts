import webSocket from '@ohos.net.webSocket';
export declare function toWebSocketRequestOptions(r7: Map<string, string>): webSocket.WebSocketRequestOptions;
export declare function getPingMsg(): ArrayBuffer;
export declare function getRandomInt(o7: any, p7: any): number;
export declare class WebSocketCloseOptionsImpl implements webSocket.WebSocketCloseOptions {
    code?: number;
    reason?: string;
    constructor(g7: number, h7: string);
}

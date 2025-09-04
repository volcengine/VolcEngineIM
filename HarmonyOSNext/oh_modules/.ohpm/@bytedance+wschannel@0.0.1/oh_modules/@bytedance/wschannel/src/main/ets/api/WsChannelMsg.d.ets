export interface IWsChannelMsg {
    /** Frame seqid */
    seqId: bigint;
    /** Frame logid */
    logId: bigint;
    /** Frame service */
    service: number;
    /** Frame method */
    method: number;
    /** Frame headers */
    headers?: Map<string, string>;
    /** Frame payload_encoding */
    payloadEncoding?: (string | undefined);
    /** Frame payload_type */
    payloadType?: (string | undefined);
    /** Frame payload */
    payload?: (Uint8Array | undefined);
    toString(): string;
}
export declare class WsChannelMsg implements IWsChannelMsg {
    seqId: bigint;
    logId: bigint;
    service: number;
    method: number;
    headers?: Map<string, string>;
    payloadEncoding?: string;
    payloadType?: string;
    payload?: Uint8Array;
    constructor();
    toString(): string;
    static builder(): WsChannelMsgBuilder;
}
export declare class WsChannelMsgBuilder {
    private _seqId;
    private _logId;
    private _service;
    private _method;
    private _headers?;
    private _payloadEncoding?;
    private _payloadType?;
    private _payload?;
    seqId(b5: bigint): this;
    logId(a5: bigint): this;
    service(z4: number): this;
    method(y4: number): this;
    headers(x4?: Map<string, string>): this;
    payloadEncoding(w4?: string): this;
    payloadType(v4?: string): this;
    payload(u4?: Uint8Array): this;
    build(): WsChannelMsg;
}

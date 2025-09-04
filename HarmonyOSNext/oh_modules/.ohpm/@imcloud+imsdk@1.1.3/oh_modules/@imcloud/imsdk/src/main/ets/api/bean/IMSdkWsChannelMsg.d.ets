export interface IMSdkWsChannelMsg {
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
    payloadEncoding?: Nullable<string>;
    /** Frame payload_type */
    payloadType?: Nullable<string>;
    /** Frame payload */
    payload?: Nullable<Uint8Array>;
}

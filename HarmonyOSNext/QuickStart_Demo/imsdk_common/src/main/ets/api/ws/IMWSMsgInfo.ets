//ws长连接传输数据
export class IMWSMsgInfo{
  seqId: bigint = BigInt(0);
  logId: bigint = BigInt(0);
  service: number = 0;
  method: number = 0;
  headers?: Map<string, string>;
  payloadEncoding?: string;
  payloadType?: string;
  payload?: Uint8Array;
}
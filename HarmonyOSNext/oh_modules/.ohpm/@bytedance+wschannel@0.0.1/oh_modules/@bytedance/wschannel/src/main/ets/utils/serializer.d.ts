import { ws_proto } from '../api/proto/index';
export declare class SerializeUtil {
    static serializeFrame(x11: ws_proto.IFrame): Uint8Array;
    static uint8ArrayToArrayBuffer(w11: Uint8Array): ArrayBuffer;
    static deserializeFrame(t11: Iterable<number>): ws_proto.IFrame;
    static deserializeFrameFromArrayBuffer(q11: ArrayBuffer): ws_proto.IFrame;
}

import { im_proto } from '../api/proto';
export declare class SerializeUtil {
    static serialize(req: im_proto.IRequest): Uint8Array;
    static uint8ArrayToArrayBuffer(array: Uint8Array): ArrayBuffer;
    static deserialize(buffer: ArrayBuffer): im_proto.IResponse;
    static deserializeU8(buffer: Uint8Array): im_proto.IResponse;
}

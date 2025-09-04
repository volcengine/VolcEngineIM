import { ws_proto } from '../api/proto/index';
import { Logger } from './Logger';
const Frame = ws_proto.Frame;
export class SerializeUtil {
    static serializeFrame(x11) {
        return new Uint8Array(Frame.encode(x11).finish());
    }
    static uint8ArrayToArrayBuffer(w11) {
        return w11.buffer.slice(w11.byteOffset, w11.byteLength + w11.byteOffset);
    }
    static deserializeFrame(t11) {
        const u11 = new Uint8Array(t11);
        try {
            return Frame.decode(u11);
        }
        catch (v11) {
            Logger.error(v11);
            throw v11;
        }
    }
    static deserializeFrameFromArrayBuffer(q11) {
        const r11 = new Uint8Array(q11);
        try {
            return Frame.decode(r11);
        }
        catch (s11) {
            Logger.error(s11);
            throw s11;
        }
    }
}

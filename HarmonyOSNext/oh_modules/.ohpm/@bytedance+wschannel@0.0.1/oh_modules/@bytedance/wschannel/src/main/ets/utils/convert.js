import { ws_proto } from '../api/proto';
import { WsChannelMsg } from '../api/WsChannelMsg';
import { bigint2Long, long2Bigint } from './tools';
export class ConvertUtil {
    static convertMsg2Frame(i9) {
        return ws_proto.Frame.create({
            seqid: bigint2Long(i9.seqId),
            logid: bigint2Long(i9.logId),
            service: i9.service,
            method: i9.method,
            headers: ConvertUtil.convertMap2Entry(i9.headers),
            payload_encoding: i9.payloadEncoding,
            payload_type: i9.payloadType,
            payload: i9.payload
        });
    }
    static convertFrame2Msg(g9) {
        let h9 = WsChannelMsg.builder()
            .seqId(long2Bigint(g9.seqid))
            .logId(long2Bigint(g9.logid))
            .service(g9.service)
            .method(g9.method);
        if (g9.headers)
            h9.headers(ConvertUtil.convertEntry2Map(g9.headers));
        if (g9.payload_encoding)
            h9.payloadEncoding(g9.payload_encoding);
        if (g9.payload_type)
            h9.payloadType(g9.payload_type);
        if (g9.payload)
            h9.payload(g9.payload);
        return h9.build();
    }
    static convertMap2Entry(...a9) {
        let b9 = new Array();
        for (let c9 of a9) {
            c9.forEach((e9, f9) => {
                b9.push({
                    key: f9,
                    value: e9,
                });
            });
        }
        return b9;
    }
    static convertEntry2Map(x8) {
        let y8 = new Map();
        for (let z8 of x8) {
            y8.set(z8.key, z8.value);
        }
        return y8;
    }
}

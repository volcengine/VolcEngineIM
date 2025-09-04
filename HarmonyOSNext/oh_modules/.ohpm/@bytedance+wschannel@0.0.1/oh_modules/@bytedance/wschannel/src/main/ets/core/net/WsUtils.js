export function toWebSocketRequestOptions(r7) {
    return new WebSocketRequestOptionsImpl({
        header: wsConvertHeaderMap(r7)
    });
}
export function getPingMsg() {
    let q7 = Uint8Array.from([137, 128, 160, 178, 235, 168]);
    return q7.buffer;
}
export function getRandomInt(o7, p7) {
    o7 = Math.ceil(o7);
    p7 = Math.floor(p7);
    return Math.floor(Math.random() * (p7 - o7) + o7);
}
class WebSocketRequestOptionsImpl {
    constructor(n7) {
        this.header = n7.header;
    }
}
function wsConvertHeaderMap(i7) {
    let j7 = {};
    i7.forEach((l7, m7) => {
        j7[m7] = l7;
    });
    return j7;
}
export class WebSocketCloseOptionsImpl {
    constructor(g7, h7) {
        this.code = g7;
        this.reason = h7;
    }
}

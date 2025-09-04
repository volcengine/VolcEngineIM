export class WsChannelMsg {
    constructor() {
        this.seqId = BigInt(0);
        this.logId = BigInt(0);
        this.service = 0;
        this.method = 0;
    }
    toString() {
        return `[seqId=${this.seqId}, logId=${this.logId}, service=${this.service}, method=${this.method}, payloadType=${this.payloadType}]`;
    }
    static builder() {
        return new WsChannelMsgBuilder();
    }
}
export class WsChannelMsgBuilder {
    constructor() {
        this._seqId = BigInt(0);
        this._logId = BigInt(0);
        this._service = 0;
        this._method = 0;
    }
    seqId(b5) {
        this._seqId = b5;
        return this;
    }
    logId(a5) {
        this._logId = a5;
        return this;
    }
    service(z4) {
        this._service = z4;
        return this;
    }
    method(y4) {
        this._method = y4;
        return this;
    }
    headers(x4) {
        this._headers = x4;
        return this;
    }
    payloadEncoding(w4) {
        this._payloadEncoding = w4;
        return this;
    }
    payloadType(v4) {
        this._payloadType = v4;
        return this;
    }
    payload(u4) {
        this._payload = u4;
        return this;
    }
    build() {
        let t4 = new WsChannelMsg();
        t4.seqId = this._seqId;
        t4.logId = this._logId;
        t4.service = this._service;
        t4.method = this._method;
        t4.headers = this._headers;
        t4.payloadEncoding = this._payloadEncoding;
        t4.payloadType = this._payloadType;
        t4.payload = this._payload;
        return t4;
    }
}

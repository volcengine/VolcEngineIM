export var ConnectionState;
(function (k5) {
    k5[k5["CONNECTION_UNKNOWN"] = 1] = "CONNECTION_UNKNOWN";
    k5[k5["CONNECTING"] = 2] = "CONNECTING";
    k5[k5["CONNECT_FAILED"] = 4] = "CONNECT_FAILED";
    k5[k5["CONNECT_CLOSED"] = 8] = "CONNECT_CLOSED";
    k5[k5["CONNECTED"] = 16] = "CONNECTED";
    k5[k5["DISCONNECTING"] = 32] = "DISCONNECTING";
})(ConnectionState || (ConnectionState = {}));
export class WsCallback {
}
export class WsConnectionConfig {
    constructor(i5, j5) {
        this.pingInterval = 60;
        this.commonParams = j5;
        this.urls = i5;
    }
    addHeaderMap(h5) {
        this.headerMap = h5;
    }
    addQueryMap(g5) {
        this.queryMap = g5;
    }
    addPingInterval(f5) {
        this.pingInterval = f5;
    }
    getPingInterval() {
        return this.pingInterval;
    }
    getUrls() {
        return this.urls;
    }
    getCommonParams() {
        return this.commonParams;
    }
    getHeaderMap() {
        return this.headerMap;
    }
    getQueryMap() {
        return this.queryMap;
    }
}

import util from '@ohos.util';
import webSocket from '@ohos.net.webSocket';
import { ConnectionState } from './IWsChannelClient';
import { wsAppStateMonitor } from '../../api/WSAppStateMonitor';
import { getRandomInt, toWebSocketRequestOptions, WebSocketCloseOptionsImpl } from './WsUtils';
import { wsNetworkChangeNotifier } from './WsNetworkChangeNotifier';
import { Logger } from '../../utils/Logger';
export class OhosChannelClient {
    constructor(u6) {
        this.wsConnection = null;
        this.url = "";
        this.config = null;
        this.connState = ConnectionState.CONNECTION_UNKNOWN;
        this.reconnectTimes = 0;
        this.reconnectTimeoutId = 0;
        this.isStoppedConnection = false;
        this.callback = u6;
        wsNetworkChangeNotifier.register(this);
    }
    destroy() {
        wsNetworkChangeNotifier.unregister(this);
        this.destroyConnection();
    }
    netAvailable(t6) {
        this.destroyConnection();
        this.wsReconnect(false);
    }
    destroyConnection() {
        if (this.wsConnection) {
            this.closeConnection(1000, "destroy connection");
            this.wsConnection.off('open');
            this.wsConnection.off('message');
            this.wsConnection.off('close');
            this.wsConnection.off('error');
            this.wsConnection = null;
        }
        else {
            this.connState = ConnectionState.CONNECTION_UNKNOWN;
        }
    }
    initWsConnection() {
        this.wsConnection = webSocket.createWebSocket();
        this.wsConnection.on('open', (r6, s6) => {
            if (r6) {
                Logger.debug(OhosChannelClient.TAG + "on open err:" + JSON.stringify(r6));
            }
            Logger.debug(OhosChannelClient.TAG + "on open, status:" + JSON.stringify(s6));
            this.connState = ConnectionState.CONNECTED;
            this.callback.onConnectionStateChanged(this.url, ConnectionState.CONNECTED, JSON.stringify(s6));
            this.resetReconnectTimes();
        });
        this.wsConnection.on('message', (p6, q6) => {
            if (p6) {
                Logger.debug(OhosChannelClient.TAG + "on message, message err:" + JSON.stringify(p6));
            }
            if (typeof q6 === "string") {
                this.callback.onTextMessage(q6);
                Logger.debug(OhosChannelClient.TAG + "text message:" + q6);
            }
            else {
                Logger.debug(OhosChannelClient.TAG + "binary message");
                this.callback.onBinaryMessage(q6);
            }
        });
        this.wsConnection.on('close', (n6, o6) => {
            if (n6) {
                Logger.debug(OhosChannelClient.TAG + "on close err:" + JSON.stringify(n6));
            }
            Logger.debug(OhosChannelClient.TAG + "on close, code:" + o6.code + ", reason:" + o6.reason);
            this.connState = ConnectionState.CONNECT_CLOSED;
            this.callback.onConnectionStateChanged(this.url, ConnectionState.CONNECT_CLOSED, JSON.stringify(o6));
            this.wsReconnect(true);
        });
        this.wsConnection.on('error', (m6) => {
            Logger.debug(OhosChannelClient.TAG + "on error:" + JSON.stringify(m6));
            this.connState = ConnectionState.CONNECT_FAILED;
            this.callback.onConnectionStateChanged(this.url, ConnectionState.CONNECT_FAILED, JSON.stringify(m6));
            this.wsReconnect(true);
        });
    }
    initClient() {
    }
    isConnected() {
        return this.connState == ConnectionState.CONNECTED;
    }
    isConnecting() {
        return this.connState == ConnectionState.CONNECTING;
    }
    isClosing() {
        return this.connState == ConnectionState.DISCONNECTING;
    }
    async openConnectionInternal(a6, b6) {
        if (b6 && this.isStoppedConnection) {
            Logger.debug(OhosChannelClient.TAG + "Ws connection has been stopped.");
            return false;
        }
        if (this.isConnected()) {
            Logger.debug(OhosChannelClient.TAG + "Ws connection has been connected, do nothing.");
            return false;
        }
        if (this.isConnecting()) {
            Logger.debug(OhosChannelClient.TAG + "Ws connection is connecting, do nothing.");
            return false;
        }
        if (a6.getUrls().length <= 0) {
            throw new Error("config urls is empty.");
        }
        this.config = a6;
        this.url = a6.getUrls()[0];
        if (this.url.indexOf('?') < 0) {
            this.url += '?';
        }
        this.url += a6.getCommonParams();
        if (a6.getQueryMap() != null) {
            let e6 = "";
            a6.getQueryMap()?.forEach((g6, h6) => {
                e6 += "&";
                e6 += h6 + "=" + g6;
            });
            this.url += e6;
        }
        let c6 = wsAppStateMonitor.isOnForeground() ? "0" : "1";
        this.url += "&is_background=" + c6;
        this.connState = ConnectionState.CONNECTING;
        this.callback.onConnectionStateChanged(this.url, ConnectionState.CONNECTING, "start connecting");
        Logger.debug(OhosChannelClient.TAG + "Ws open connection:" + this.url);
        this.destroyConnection();
        this.initWsConnection();
        let d6 = await this.wsConnection?.connect(this.url, toWebSocketRequestOptions(a6.getHeaderMap()));
        if (d6) {
            Logger.debug(OhosChannelClient.TAG + "Ws open connected:" + this.url);
        }
        else {
            Logger.debug(OhosChannelClient.TAG + "Ws open failed:" + this.url);
            this.connState = ConnectionState.CONNECT_FAILED;
            this.callback.onConnectionStateChanged(this.url, ConnectionState.CONNECT_FAILED, "ws connect failed");
        }
        return d6 == undefined ? false : true;
    }
    async openConnection(z5) {
        this.resetReconnectConfig();
        return this.openConnectionInternal(z5, false);
    }
    async stopConnection() {
        this.isStoppedConnection = true;
        this.closeConnection(1000, "stop connection");
        return true;
    }
    async onParameterChange(y5) {
        Logger.debug(OhosChannelClient.TAG + "onParameterChange");
        this.destroyConnection();
        return await this.openConnection(y5);
    }
    sendMessage(v5) {
        Logger.debug(OhosChannelClient.TAG + "sendMessage:" + v5);
        if (this.wsConnection == null || !this.isConnected()) {
            return new Promise(((x5) => {
                Logger.debug(OhosChannelClient.TAG + "sendMessage:" + false);
                x5(false);
            }));
        }
        return this.wsConnection.send(v5);
    }
    closeConnection(s5, t5) {
        if (this.wsConnection == null) {
            this.connState = ConnectionState.CONNECTION_UNKNOWN;
            return;
        }
        this.connState = ConnectionState.DISCONNECTING;
        let u5 = new WebSocketCloseOptionsImpl(s5, t5);
        this.wsConnection.close(u5);
    }
    wsReconnect(q5) {
        if (this.config == null || this.isStoppedConnection) {
            return;
        }
        if (this.isConnecting() || this.isConnected()) {
            Logger.debug(OhosChannelClient.TAG + "wsReconnect state is connecting or connected:" + this.connState);
            return;
        }
        let r5 = 0;
        if (q5 && this.reconnectTimes++ > 0) {
            r5 = this.getDelaySeconds(this.reconnectTimes);
        }
        Logger.debug(OhosChannelClient.TAG + "wsReconnect times:" + this.reconnectTimes + " delay:" + r5);
        this.delayWsReconnect(r5);
    }
    resetReconnectTimes() {
        this.reconnectTimes = 0;
    }
    delayWsReconnect(o5) {
        this.resetReconnectTimer();
        if (o5 == 0) {
            if (this.config != null) {
                this.openConnectionInternal(this.config, true);
            }
            return;
        }
        this.reconnectTimeoutId = setTimeout(() => {
            if (this.config != null) {
                this.openConnectionInternal(this.config, true);
            }
            this.reconnectTimeoutId = 0;
        }, 1000 * o5);
    }
    resetReconnectTimer() {
        if (this.reconnectTimeoutId != 0) {
            clearTimeout(this.reconnectTimeoutId);
        }
    }
    getDelaySeconds(l5) {
        if (l5 == 1) {
            return 1;
        }
        if (l5 >= OhosChannelClient.MAX_RECONNECT_TIMES) {
            this.resetReconnectTimes();
            let n5 = OhosChannelClient.DEFAULT_PING_INTERVAL;
            if (this.config != null) {
                n5 = this.config.getPingInterval();
            }
            return n5;
        }
        let m5 = Math.min((5 * (1 << l5) + getRandomInt(0, 5)), OhosChannelClient.BACKOFF_TIMEOUT_SECONDS);
        return m5;
    }
    resetReconnectConfig() {
        this.isStoppedConnection = false;
        this.resetReconnectTimes();
        this.resetReconnectTimer();
    }
}
OhosChannelClient.TAG = "[OhosChannelClient]";
OhosChannelClient.MAX_RECONNECT_TIMES = 5;
OhosChannelClient.BACKOFF_TIMEOUT_SECONDS = 120;
OhosChannelClient.DEFAULT_PING_INTERVAL = 60;
OhosChannelClient.textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });

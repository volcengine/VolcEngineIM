import { wsAppStateMonitor } from '../api/WSAppStateMonitor';
import { WsChannelMsg } from '../api/WsChannelMsg';
import { ConvertUtil } from '../utils/convert';
import { Logger } from '../utils/Logger';
import { SerializeUtil } from '../utils/serializer';
import { ConnectionState, WsCallback, WsConnectionConfig } from './net/IWsChannelClient';
import { OhosChannelClient } from './net/OhosChannelClient';
class OhosWsCallBack extends WsCallback {
    constructor(w8) {
        super();
        this.wsChannel = w8;
    }
    onBinaryMessage(v8) {
        this.wsChannel.onReceiveMessage(v8);
    }
    onTextMessage(u8) {
    }
    onConnectionStateChanged(r8, s8, t8) {
        this.wsChannel.onConnectionStateChanged(s8, t8);
        if (s8 == ConnectionState.CONNECTED) {
            this.wsChannel.sendAppStateChangedMsg(wsAppStateMonitor.isOnForeground());
        }
    }
    onConnectionError(p8, q8) {
    }
}
class OhosAppStateListener {
    constructor(o8) {
        this.wsChannel = o8;
    }
    onEnterToForeground() {
        this.wsChannel.onEnterToForeground();
    }
    onEnterToBackground() {
        this.wsChannel.onEnterToBackground();
    }
}
export class WsChannelImpl {
    constructor(m8, n8) {
        this.channelInfo = m8;
        this.wsEventListener = n8;
        this.wsClient = new OhosChannelClient(new OhosWsCallBack(this));
        this.wsAppState = new OhosAppStateListener(this);
        wsAppStateMonitor.registerAppStateListener(this.wsAppState);
    }
    destroy() {
        wsAppStateMonitor.unRegisterAppStateListener(this.wsAppState);
        this.wsClient.destroy();
    }
    getConnectionConfig() {
        let l8 = new WsConnectionConfig(this.channelInfo.getUrls(), this.channelInfo.createCommonParams());
        l8.addHeaderMap(this.channelInfo.getHeaders());
        l8.addQueryMap(this.channelInfo.getExtraParam());
        return l8;
    }
    init() {
        this.wsClient.initClient();
    }
    startConnection() {
        if (this.isConnected()) {
            return new Promise(((k8) => {
                k8(true);
            }));
        }
        return this.wsClient.openConnection(this.getConnectionConfig());
    }
    stopConnection() {
        return this.wsClient.stopConnection();
    }
    onParamChanged(i8) {
        this.channelInfo = i8;
        return this.wsClient.onParameterChange(this.getConnectionConfig());
    }
    isConnected() {
        return this.wsClient.isConnected();
    }
    sendMsg(b8) {
        try {
            const f8 = ConvertUtil.convertMsg2Frame(b8);
            let g8 = SerializeUtil.serializeFrame(f8);
            Logger.debug(`sendMessage, payloadLength=${b8.payload?.byteLength}, byteOffset=${g8.byteOffset}, byteLength=${g8.byteLength}`);
            let h8 = SerializeUtil.uint8ArrayToArrayBuffer(g8);
            return this.wsClient.sendMessage(h8);
        }
        catch (e8) {
            Logger.warn(`BaseWsService, sendMessage error=${e8}`);
        }
        return new Promise(((d8) => {
            d8(false);
        }));
    }
    onReceiveMessage(z7) {
        let a8 = this.getMsgFromBuffer(z7);
        if (a8 != undefined) {
            Logger.debug(`onReceiveMessage=${a8}}`);
            this.wsEventListener.onMsgReceive(a8);
        }
    }
    onConnectionStateChanged(x7, y7) {
        this.wsEventListener.onConnectStateChange(x7, y7);
    }
    sendAppStateChangedMsg(u7) {
        if (!this.wsClient.isConnected()) {
            return;
        }
        let v7 = new Map();
        v7.set(WsChannelImpl.APP_STATE_BACKGROUND_KEY, u7 ? "0" : "1");
        let w7 = WsChannelMsg.builder()
            .service(WsChannelImpl.APP_STATE_CHANGE_SERVICE)
            .method(WsChannelImpl.APP_STATE_CHANGE_METHOD)
            .headers(v7)
            .payloadEncoding("pb")
            .payloadType("pb")
            .payload(Uint8Array.from([0]))
            .build();
        this.sendMsg(w7);
    }
    onEnterToForeground() {
        Logger.debug("WSChannel enter to foreground");
        this.sendAppStateChangedMsg(true);
    }
    onEnterToBackground() {
        Logger.debug("WSChannel enter to background");
        this.sendAppStateChangedMsg(false);
    }
    getMsgFromBuffer(s7) {
        try {
            return ConvertUtil.convertFrame2Msg(SerializeUtil.deserializeFrameFromArrayBuffer(s7));
        }
        catch (t7) {
            Logger.warn('getFrameFromBuffer error', t7);
            return undefined;
        }
    }
}
WsChannelImpl.APP_STATE_CHANGE_SERVICE = 9000;
WsChannelImpl.APP_STATE_CHANGE_METHOD = 4;
WsChannelImpl.APP_STATE_BACKGROUND_KEY = "IsBackground";

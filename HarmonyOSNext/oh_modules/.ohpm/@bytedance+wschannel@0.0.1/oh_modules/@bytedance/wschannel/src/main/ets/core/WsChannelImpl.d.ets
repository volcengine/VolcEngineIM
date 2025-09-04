import { ChannelInfo } from '../api/ChannelInfo';
import { WsChannelMsg } from '../api/WsChannelMsg';
import { WsEventListener } from '../api/WsEventListener';
import { ConnectionState } from './net/IWsChannelClient';
import { WsChannel } from './WsChannel';
export declare class WsChannelImpl implements WsChannel {
    private channelInfo;
    private wsEventListener;
    private wsAppState;
    private wsClient;
    private static APP_STATE_CHANGE_SERVICE;
    private static APP_STATE_CHANGE_METHOD;
    private static APP_STATE_BACKGROUND_KEY;
    constructor(m8: ChannelInfo, n8: WsEventListener);
    destroy(): void;
    private getConnectionConfig;
    init(): void;
    startConnection(): Promise<boolean>;
    stopConnection(): Promise<boolean>;
    onParamChanged(i8: ChannelInfo): Promise<boolean>;
    isConnected(): boolean;
    sendMsg(b8: WsChannelMsg): Promise<boolean>;
    onReceiveMessage(z7: ArrayBuffer): void;
    onConnectionStateChanged(x7: ConnectionState, y7: string): void;
    sendAppStateChangedMsg(u7: boolean): void;
    onEnterToForeground(): void;
    onEnterToBackground(): void;
    private getMsgFromBuffer;
}

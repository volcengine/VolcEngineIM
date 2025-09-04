import { ConnectionState } from '../core/net/IWsChannelClient';
import { IWsChannelMsg } from './WsChannelMsg';
export interface WsEventListener {
    onConnectStateChange(state: ConnectionState, connectLog: string): void;
    onMsgReceive(msg: IWsChannelMsg): void;
}
export interface PsmIdentifier {
    serviceId: number;
    methodId: number;
}

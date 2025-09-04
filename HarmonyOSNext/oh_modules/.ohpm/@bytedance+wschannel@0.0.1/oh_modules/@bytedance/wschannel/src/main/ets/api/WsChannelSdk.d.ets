import { ChannelInfo } from './ChannelInfo';
import { WsEventListener } from './WsEventListener';
import { WsChannel } from '../core/WsChannel';
export declare class WsChannelSdk {
    static registerChannel(c5: ChannelInfo, d5: WsEventListener): WsChannel;
}

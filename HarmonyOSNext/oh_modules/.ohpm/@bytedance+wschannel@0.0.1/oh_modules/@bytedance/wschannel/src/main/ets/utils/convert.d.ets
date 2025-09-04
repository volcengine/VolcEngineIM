import { ws_proto } from '../api/proto';
import { IWsChannelMsg, WsChannelMsg } from '../api/WsChannelMsg';
export declare class ConvertUtil {
    static convertMsg2Frame(i9: IWsChannelMsg): ws_proto.IFrame;
    static convertFrame2Msg(g9: ws_proto.IFrame): WsChannelMsg;
    static convertMap2Entry(...a9: Map<string, string>[]): ws_proto.Frame.IExtendedEntry[];
    static convertEntry2Map(x8: ws_proto.Frame.IExtendedEntry[]): Map<string, string>;
}

import { IMSdkWsChannelMsg } from '../bean/IMSdkWsChannelMsg';
export interface IMSdkWsDataReceiveListener {
    onMsgReceive: (msg: IMSdkWsChannelMsg) => void;
}

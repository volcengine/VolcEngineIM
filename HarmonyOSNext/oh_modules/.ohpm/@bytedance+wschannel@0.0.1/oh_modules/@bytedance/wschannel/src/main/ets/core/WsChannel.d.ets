import { ChannelInfo } from '../api/ChannelInfo';
import { WsChannelMsg } from '../api/WsChannelMsg';
export interface WsChannel {
    /**
     * 开始连接 (如果连接已经连上，操作无效)
     */
    startConnection(): Promise<boolean>;
    /**
     * 断开连接
     */
    stopConnection(): Promise<boolean>;
    /**
     * 参数变化，会触发内部重连
     *
     * @param channel
     */
    onParamChanged(channel: ChannelInfo): Promise<boolean>;
    /**
     * 是否处于联通中
     *
     * @return 是否联通
     */
    isConnected(): boolean;
    /**
     * 发送消息
     *
     * @param wsMsg 消息
     */
    sendMsg(wsMsg: WsChannelMsg): Promise<boolean>;
    /**
     * 销毁连接
     */
    destroy(): void;
}

import { RequestItem } from '../../request/RequestItem';
import { IMSdkWsDataReceiveListener } from '../listener/IMSdkWsDataReceiveListener';
import { im_proto } from '../proto';
/**
 * imsdk内部的网络依赖，用于收发消息。主要包括短链依赖，长链依赖
 */
export interface IIMNetworkDepend {
    /**
     * 长链依赖
     */
    wsDepend: IIMSdkWsDepend;
    /**
     * 短链依赖
     */
    httpDepend: IIMSdkHttpDepend;
    /**
     * 当前网络是否可用
     * @returns
     */
    isNetAvailable(): boolean;
}
/**
 * IIMSdkHttpDepend
 */
export interface IIMSdkHttpDepend {
    /**
     * 发送http请求
     * @param request
     * @returns
     */
    sendRequest(item: RequestItem): Promise<im_proto.Response>;
}
/**
 * IIMSdkWsDepend
 */
export interface IIMSdkWsDepend {
    /**
     * 初始化
     */
    init(): void;
    /**
     * 销毁
     */
    dispose(): void;
    /**
     * 设置收消息回调
     * @param listener
     */
    setWsDataReceiveListener(listener: IMSdkWsDataReceiveListener): void;
    /**
     * 发送消息
     * @param msg
     */
    send(item: RequestItem): void;
    /**
     * 长连接是否已建连
     * @returns
     */
    isWsConnect(): boolean;
}

import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { RequestItem } from './RequestItem';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkWsChannelMsg } from '../api/bean/IMSdkWsChannelMsg';
/**
 * RequestManager
 */
export declare class RequestManager extends IMSdkBaseObject {
    private reqMap;
    private readonly httpClient;
    private readonly wsClient;
    private readonly newMsgHandlerManager;
    constructor(context: IMSdkContext);
    init(): void;
    dispose(): void;
    /**
     * send，发送请求
     * @param requestItem
     * @returns
     */
    send(requestItem: RequestItem): Promise<RequestItem>;
    /**
     * 长连接是否已建连
     * @returns
     */
    private isWsConnect;
    /**
     * 使用http发送
     * @param item
     * @returns
     */
    protected sendByHttp(item: RequestItem): Promise<RequestItem>;
    /**
     * 使用长连接发送
     * @param item
     * @returns
     */
    protected sendByWs(item: RequestItem): Promise<RequestItem>;
    /**
     * 收到长连接消息的处理
     */
    onReceiveData(msg: IMSdkWsChannelMsg): void;
    /**
     * 收到新消息的回调
     * @param item
     */
    protected onReceiveNewMsg(item: RequestItem): void;
    private buildUrlAndPath;
}

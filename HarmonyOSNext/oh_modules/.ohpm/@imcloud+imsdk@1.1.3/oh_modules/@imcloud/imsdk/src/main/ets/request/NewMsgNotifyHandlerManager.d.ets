import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { IMSdkContext } from '../client/IMSdkContext';
import { RequestItem } from './RequestItem';
/**
 * NewMsgNotifyHandlerManager
 * 统一新消息
 * 处理
 */
export declare class NewMsgNotifyHandlerManager extends IMSdkBaseObject {
    private readonly newMsgNotifyMixHandler;
    private readonly newP2PMsgNotifyHandler;
    private readonly newLiveMsgNotifyHandler;
    constructor(ctx: IMSdkContext);
    handleResponse(item: RequestItem): void;
}

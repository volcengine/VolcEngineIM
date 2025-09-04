import { Message } from '../api/model/Message';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare class SendMsgCache extends IMSdkBaseObject {
    private TAG;
    private msgLruCache;
    constructor(context: IMSdkContext);
    checkUpdate(msg: Message): void;
}

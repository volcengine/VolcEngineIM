import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { Message } from '../api/model/Message';
export declare class IMSearchModel extends IMSdkBaseObject {
    constructor(context: IMSdkContext);
    /***
     * 立刻建立搜索表索引
     */
    buildSearchIndex(): Promise<void>;
    /***
     * 会话内消息搜索
     */
    queryMsgsByConvId(conversationId: string, key: string, limit: number, createdTime?: number): Promise<Nullable<Message[]>>;
}

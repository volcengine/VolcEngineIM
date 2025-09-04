import { IMResult } from '../../../api/bean/IMHandlerResult';
import { MessageReadStatusModel } from '../../../api/bean/message/MessageReadStatusModel';
import { P2PReadConversationInfo } from '../../../api/bean/p2p/P2PReadConversationInfo';
import { Message } from '../../../api/model/Message';
import { IMSdkBaseObject } from '../../../core/IMSdkBaseObject';
export declare class BatchQueryHelper extends IMSdkBaseObject {
    requestTime: number;
    batchGet(messageListP: Message[], from: string): Promise<IMResult<Map<bigint, MessageReadStatusModel>>>;
    batchGetOpt(list: P2PReadConversationInfo[], from: string): Promise<Map<bigint, MessageReadStatusModel>>;
}

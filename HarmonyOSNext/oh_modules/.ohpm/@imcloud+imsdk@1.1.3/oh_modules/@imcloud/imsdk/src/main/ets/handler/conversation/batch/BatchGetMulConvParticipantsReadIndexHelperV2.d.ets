import { MessageReadStatusModel } from '../../../api/bean/message/MessageReadStatusModel';
import { P2PReadConversationInfo } from '../../../api/bean/p2p/P2PReadConversationInfo';
import { Message } from '../../../api/model/Message';
import { IMSdkContext } from '../../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../../core/IMSdkBaseObject';
export declare class BatchGetMulConvParticipantsReadIndexHelperV2 extends IMSdkBaseObject {
    constructor(context: IMSdkContext);
    processPtoPMessageList(pTopMessageList: Message[], inboxType: number): Promise<Nullable<[Map<bigint, MessageReadStatusModel>, P2PReadConversationInfo[]]>>;
    private processExistConversationMessage;
    private processConversationMessage;
    private processParticipantIndexInfo;
}

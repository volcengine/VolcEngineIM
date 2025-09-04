import { P2PReadConversationInfo } from '../../../api/bean/p2p/P2PReadConversationInfo';
import { P2PReadNotifyContent } from '../../../api/bean/p2p/P2PReadNotifyContent';
import { Message } from '../../../api/model/Message';
import { IMSdkContext } from '../../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../../core/IMSdkBaseObject';
import { BatchGetMulConvParticipantsReadIndexHelperV2 } from './BatchGetMulConvParticipantsReadIndexHelperV2';
export declare class BatchGetMultiConversationParticipantsReadIndexHelper extends IMSdkBaseObject {
    private pTopMessageList;
    private revealList;
    private inboxType;
    private isDelayHandlepTopMsg;
    private isDelayHandleReadStatus;
    readonly helperOpt: BatchGetMulConvParticipantsReadIndexHelperV2;
    constructor(context: IMSdkContext);
    handlerReadCmdMsg(inboxType: number, msg: Message): Promise<void>;
    private delayToHandlePtoPMsgList;
    private delayToHandleReadStatus;
    buildPtoPReadConversationInfo(message: Message, inboxType: number, content: P2PReadNotifyContent): P2PReadConversationInfo;
    private processPtoPMessageList;
    private batchGetMsg;
    private onPtoPReadConversationInfoCallback;
}

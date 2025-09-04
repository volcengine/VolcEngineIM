import { IMResult } from '../../../api/bean/IMHandlerResult';
import { MessageReadStatusModel } from '../../../api/bean/message/MessageReadStatusModel';
import { P2PReadConversationInfo } from '../../../api/bean/p2p/P2PReadConversationInfo';
import { Message } from '../../../api/model/Message';
import { IMSdkContext } from '../../../client/IMSdkContext';
import { RequestItem } from '../../../request/RequestItem';
import { IMBaseHandler } from '../../base/IMBaseHandler';
export declare class BatchGetMultiConversationParticipantsReadIndexHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    getOriginal(messageListP: Message[], from: string): Promise<IMResult<Map<bigint, MessageReadStatusModel>>>;
    getOpt(pTopReadConvInfo: Nullable<P2PReadConversationInfo[]>, from: string): Promise<IMResult<Map<bigint, MessageReadStatusModel>>>;
    get(messageListP: Message[], from: string): Promise<IMResult<Map<bigint, MessageReadStatusModel>>>;
    private getByDistributeInboxType;
    getInternal(inboxType: number, messageListP: Message[], from: string): Promise<IMResult<Map<bigint, MessageReadStatusModel>>>;
    private getFull;
    private getFiltered;
    processNormalMsgResponse(item: RequestItem, msgList: Message[]): Promise<Map<bigint, MessageReadStatusModel>>;
    /**
     * @param item
     * @param pTopReadConversationInfo
     * @returns Map<每一个消息msgId, 对应的已读状态MessageReadStatusModel>
     */
    processPtoPResponse(item: RequestItem, pTopReadConversationInfo: P2PReadConversationInfo[]): Promise<Map<bigint, MessageReadStatusModel>>;
}

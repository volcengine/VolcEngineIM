import { DiscontinuousMessageSourceEnum, TraceStruct } from '../../api/bean/message/ReceiveMsgExtra';
import { ISaveMsgResult } from '../../api/bean/message/SaveMsgResult';
import { Conversation } from '../../api/model/Conversation';
import { Message } from '../../api/model/Message';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class NewMsgNotifyMixHandler extends IMBaseHandler {
    get tag(): string;
    constructor(context: IMSdkContext);
    handleResponse(item: RequestItem): void;
    private notifyByUser;
    private createReceiveTrace;
    private notifyModel;
    private notifyByUserLink;
    private processNotify;
}
export declare class ProcessNotifyResult {
    isIgnored: boolean;
    isCursorDiscontinuous: boolean;
    isDelayCursorDiscontinuous: boolean;
    isSucceed: boolean;
    isMessageNew: boolean;
    isCheckUpdated: boolean;
    isProcessedBySendHandler: boolean;
    message: Nullable<Message>;
    conversation: Nullable<Conversation>;
    isTemp: boolean;
    everDeleted: boolean;
    traceStruct: Nullable<TraceStruct>;
    msgTracePath: Nullable<im_proto.MsgTracePath>;
    timeCostMap: Nullable<Map<string, number>>;
    filterLocalExt: Nullable<Map<string, string>>;
    inboxType: number;
    badgeCount: number;
    logId: Nullable<string>;
    isBathOpt: boolean;
    connStatus: number;
    saveMsgResult: ISaveMsgResult | undefined;
    getMessageSource: DiscontinuousMessageSourceEnum | undefined;
    toString(): string;
}

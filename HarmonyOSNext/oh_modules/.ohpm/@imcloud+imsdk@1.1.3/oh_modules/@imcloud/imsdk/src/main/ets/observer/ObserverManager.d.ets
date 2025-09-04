import { StatusCode } from '../api/const/consts';
import { Conversation } from '../api/model/Conversation';
import { Message } from '../api/model/Message';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { IConversationAuditObserver } from './IConversationAuditObserver';
import { IConversationListObserver } from './IConversationListObserver';
import { IConversationMemberObserver } from './IConversationMemberObserver';
import { IConversationObserver } from './IConversationObserver';
import { ILoginObserver } from './ILoginObserver';
import { IMessageObserver } from './IMessageObserver';
import { IP2PMessageObserver } from './IP2PMessageObserver';
import { IStrangerBoxObserver } from './IStrangerBoxObserver';
import { IStrangerListObserver } from './IStrangerListObserver';
import { LocalPropertyItem, ModifyMsgPropertyMsg } from '../api/model/MessageProperty';
import { ReceiveMsgExtra } from '../api/bean/message/ReceiveMsgExtra';
import { IMsgReadStatusObserver } from './IReadStatusObserver';
import { IConMsgReadCountObserver } from '../model/ReadStatusModel';
export interface IObserverManager {
    registerMessageObserver(observer: IMessageObserver): void;
    unregisterMessageObserver(observer: IMessageObserver): void;
}
/**
 * 回调管理
 * 对应Android ObserverUtils
 */
export declare class ObserverManager extends IMSdkBaseObject implements IObserverManager {
    private readonly globalMessageObserverSet;
    private readonly loginObserverSet;
    private readonly messageObserverMap;
    private readonly conversationObserverMap;
    private readonly conversationMemberObserverMap;
    private readonly conversationListObserverMap;
    private readonly strangerListObserverMap;
    private readonly p2pMsgObserverMap;
    private readonly strangerBoxObserverSet;
    private readonly conversationAuditObserverSet;
    private readonly readStatusObserver;
    readonly msgReadCountObservers: Set<IConMsgReadCountObserver>;
    constructor(context: IMSdkContext);
    onInstanceDestroy(): void;
    registerMessageObserver(observer: IMessageObserver): void;
    unregisterMessageObserver(observer: IMessageObserver): void;
    registerMessageObserverByCid(conversationId: string, observer: IMessageObserver): void;
    unregisterMessageObserverByCid(conversationId: string, observer: IMessageObserver): void;
    registerConversationMemberObserver(conversationId: string, observer: IConversationMemberObserver): void;
    unregisterConversationMemberObserver(conversationId: string, observer: IConversationMemberObserver): void;
    registerLoginObserver(observer: ILoginObserver): void;
    registerConversationListObserver(observer: IConversationListObserver): void;
    unregisterConversationListObserver(observer: IConversationObserver): void;
    registerMsgReadCountObserver(observer: IConMsgReadCountObserver): void;
    unregisterMsgReadCountObserver(observer: IConMsgReadCountObserver): void;
    registerConversationObserver(observer: IConversationObserver): void;
    unregisterConversationObserver(observer: IConversationObserver): void;
    registerP2pMsgObserver(observer: IP2PMessageObserver): void;
    unregisterP2pMsgObserver(observer: IP2PMessageObserver): void;
    registerStrangerBoxObserver(observer: IStrangerBoxObserver): void;
    unregisterStrangerBoxObserver(observer: IStrangerBoxObserver): void;
    registerStrangerListObserver(observer: IStrangerListObserver): void;
    unregisterStrangerListObserver(observer: IStrangerListObserver): void;
    registerConversationAuditObserver(observer: IConversationAuditObserver): void;
    unregisterConversationAuditObserver(observer: IConversationAuditObserver): void;
    registerReadStatusByCid(conversationId: string, observer: IMsgReadStatusObserver): void;
    unregisterReadStatusByCid(conversationId: string, observer: IMsgReadStatusObserver): void;
    getConversationListObserver(): Set<IConversationListObserver>;
    getConversationObserver(): Set<IConversationObserver>;
    getConversationMessageObserver(): Map<string, Set<IMessageObserver>>;
    getGlobalMessageObserver(): Set<IMessageObserver>;
    getStrangerListObserver(): Set<IStrangerListObserver>;
    getPtoPMsgObserverMap(): Set<IP2PMessageObserver>;
    getStrangerBoxObserverSet(): Set<IStrangerBoxObserver>;
    getConversationMemberObserver(): Map<string, Set<IConversationMemberObserver>>;
    unregisterLoginObserver(observer: ILoginObserver): void;
    onLoginStateChanged(isLogin: boolean): void;
    onSendModifyPropertyMsg(statusCode: number, modifyMsgPropertyMsg: Nullable<ModifyMsgPropertyMsg>): void;
    onSendMessage(statusCode: number, message: Message): void;
    onGetMessage(from: string, msgSource: number, msgList: Message[], extra?: ReceiveMsgExtra): void;
    onGetPtoPMessage(inboxType: number, sendType: number, newMsg: Message): void;
    onSendMessageAsyncResp(msg: Message, isUpdateMsgProperty: boolean): void;
    onUpdateMessage(conversationId: string, msg: Message[]): void;
    onEditMessage(conversationId: string, msg: Message[]): void;
    onAddMessage(msg: Message, statusCode: StatusCode): void;
    onRecallMessage(msgRecalled: Message): void;
    onClearMessage(convId: string, needNotify: boolean): void;
    onDelMessage(msg: Message): void;
    onMemberChange(conversation: Conversation): void;
    onGetModifyPropertyMsg(msg: Message, oldPropertyMap: Map<string, LocalPropertyItem[]>, property: Map<string, LocalPropertyItem[]>): void;
    onLeaveConversation(conversation: Conversation, from: string): Promise<void>;
}

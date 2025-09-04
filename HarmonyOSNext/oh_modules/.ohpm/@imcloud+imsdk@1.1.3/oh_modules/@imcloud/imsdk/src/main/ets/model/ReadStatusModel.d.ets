import { IMResult } from '../api/bean/IMHandlerResult';
import { Message } from '../api/model/Message';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { IConversationMemberObserver } from '../observer/IConversationMemberObserver';
import { Conversation } from '../api/model/Conversation';
import { IMsgReadStatusObserver } from '../observer/IReadStatusObserver';
import { IP2PMessageObserver } from '../observer/IP2PMessageObserver';
import { MessageReadStatusModel } from '../api/bean/message/MessageReadStatusModel';
export interface IReadStatusModel {
    /**
     * @param selfMsg 给定一个消息实体，获取该消息实体在群聊中的未读uid列表
     * @param needRequestNet 是否需要请求网络接口，IM-SDK内部会做2秒内的冗余请求去重
     * @returns [不包含自己的已读uid列表，不包含自己的所有可读uid列表]
     */
    getMessageReadStatusAsync(selfMsg: Message, needRequestNet: boolean): Promise<IMResult<[bigint[], bigint[]]>>;
    /**
     * @param msgListReceived 收到别人的消息时，更新readIndex和readOrder
     * @returns 更新是否成功
     */
    updateReadIndexOnGetOtherMsg(msgListReceived: Message[]): Promise<Nullable<boolean>>;
}
export interface IReadStatusUpdateObserver {
    /**
     * 已读状态更新的回调
     * @param info
     */
    onReadStatusUpdated: (uuid: string, safeReaderList: bigint[], allList: bigint[]) => void;
}
/**
 * 会话消息已读数变化回调
 */
export interface IConMsgReadCountObserver {
    onReadCountChange: (msgReadStatusMap: Map<bigint, MessageReadStatusModel>) => void;
}
export declare class ReadStatusModel extends IMSdkBaseObject implements IReadStatusModel, IConversationMemberObserver, IP2PMessageObserver, IMsgReadStatusObserver {
    private readonly indexToOrderLru;
    private readonly readStatusMap;
    private hasRequestMinIndex;
    private lastReadStatusNetRequestTimestamp;
    private readStatusUpdateObserver;
    private readStatusSpotMessage;
    private enableMsgRead;
    private conversationId;
    constructor(context: IMSdkContext, enableMsgRead: boolean, conversationId: string);
    /**
     * 群聊成员变化的监听回调，提前去计算消息已读数
     * @param conversation
     */
    onMemberChange(conversation: Conversation): void;
    onGetMsg(msgList: Message[]): void;
    private prefetchAndUpdateMinIndex;
    register(): void;
    unregister(): void;
    registerReadStatusObserver(observer: IReadStatusUpdateObserver): void;
    updateReadStatusSpotMessage(message: Message): void;
    onGetPtoPMessage(inboxType: number, sendType: number, pTopMessage: Message): Promise<void>;
    requestUpdateMinIndexAndCallback(selfMsg: Message): Promise<Nullable<[bigint[], bigint[]]>>;
    private updateMinIndex;
    /**
     * @param selfMsg 给定一个消息实体，获取该消息实体在群聊中的未读uid列表
     * @param needRequestNet 是否需要请求网络接口，IM-SDK内部会做2秒内的冗余请求去重
     * @returns [不包含自己的未读uid列表，不包含自己的所有可读uid列表]
     */
    getMessageReadStatusAsync(selfMsg: Message, needRequestNet: boolean): Promise<IMResult<[bigint[], bigint[]]>>;
    /**
     * @param selfMsg 需要查询的消息
     * @returns 使用本地的数据计算已读数
     */
    private getReadAndAllByLocal;
    /**
     * 根据消息和相应的map获取 Pair<不包含自己的已读的群成员id, 不包含自己的所有能读到消息的群成员id><br>
     * 分子过滤Message.index未更新的情况
     *
     * @param selfMsg 需要查询的消息
     * @return Pair<不包含自己的已读的群成员id, 不包含自己的所有能读到消息的群成员id>
     */
    private getReadAndAllMemberIdsOpt;
    private hasReadMessage;
    /**
     * 收到别人的消息时，更新readIndex和readOrder
     * @param msgListReceived
     */
    updateReadIndexOnGetOtherMsg(msgListReceived: Message[]): Promise<boolean>;
    private updateReadIndex;
    private updateReadIndexInMemoryIfNeeded;
    private computeReadOrderOpt;
    /**
     * 从成员表和已读表中load数据
     *
     * @param conversationId 会话id
     * @return true：需要更新数据库，false：不需要更新数据库
     */
    private loadIndexInfoFromMemberAndReadDB;
    /**
     * 对比内存数据和db数据，获取要插入的item
     * @param memberSetFromDb
     * @param mapSetFromMemo
     * @returns
     */
    private getInsertSet;
    /**
     * 对比内存数据和db数据，获取删除的item
     * @param memberSetFromDb
     * @param mapSetFromMemo
     * @returns
     */
    private getDeleteSet;
}
export declare class NeedUpdateReadStateItem {
    needAllUpdate: boolean;
    needUpdateSet: Set<bigint>;
    needDeleteSet: Set<bigint>;
    needUpdateDB(): boolean;
}

import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMMsgDataSource, MsgQueryParams, MsgUpdateParams } from '../datasource/IMMsgDataSource';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import { Message } from '../../api/model/Message';
import { Conversation } from '../../api/model/Conversation';
import { Range } from '../../manager/RecentLinkRangeManager';
import { TaskResultSet } from '../rdb/thread/TaskResultSet';
/**
 * IMMsgDao
 * 消息表存储
 */
export declare class IMMsgDao extends IMSdkBaseObject implements IMMsgDataSource {
    static COUNT: string;
    constructor(context: IMSdkContext);
    getLastMsgIndex(conversationId: string): Promise<bigint>;
    getMaxIndexV2(conversationId: string): Promise<bigint>;
    getMsgByServerId(conversationId: string, msgServerId: bigint): Promise<Nullable<Message>>;
    batchGetMsgByParams(conversationId: Nullable<string>, params: MsgQueryParams): Promise<Nullable<Message[]>>;
    getMsgByUuid(conversationId: string, msgUuid: string): Promise<Nullable<Message>>;
    /**
     * 根据msgUuid查询lastHintMessage
     */
    getLastHintMessageByUuid(conversationId: Nullable<string>, msgUuid: Nullable<string>): Promise<Nullable<Message>>;
    getLastShowMsgByUuid(conversationId: Nullable<string>, msgUuid: Nullable<string>): Promise<Nullable<Message>>;
    getMsgArray(conversationId: string): Promise<Message[] | undefined>;
    /**
     * 返回的消息列表逆序：[0] 的orderIndex要大于[1]
     * @param conversationId
     * @param limit
     * @param msgTypeFilter
     * @returns
     */
    initMessageList(conversationId: string, limit: number, msgTypeFilter?: number[]): Promise<Message[] | undefined>;
    /**
     * 在db中查询缺失的index
     * @param conversationId
     * @param leakIndexList
     * @returns
     */
    checkMissedMsgIndexV2List(conversationId: string, leakIndexList: bigint[]): Promise<bigint[] | undefined>;
    /**
     * 返回的消息列表逆序：[0] 的orderIndex要大于[1]
     * TODO 函数参数 优化为一个QueryParams
     * @param conversationId
     * @param fromMsgOrderIndex
     * @param minOrderIndex
     * @param limit
     * @param msgTypeFilter
     * @param includeFromOrderIndex 返回的数据是否包括fromMsgOrderIndex
     * @returns
     */
    loadOlderMessageList(conversationId: string, fromMsgOrderIndex: string, limit: number, msgTypeFilter?: number[], includeFromOrderIndex?: boolean): Promise<Nullable<Message[]>>;
    /**
     * 返回的消息列表逆序：[0] 的orderIndex要大于[1]
     * @param conversationId
     * @param fromMsgOrderIndex
     * @param limit
     * @param msgTypeFilter
     * @param includeFromOrderIndex 返回的数据是否包括fromMsgOrderIndex
     * @returns
     */
    loadNewerMessageList(conversationId: string, fromMsgOrderIndex: string, limit: number, msgTypeFilter?: number[], includeFromOrderIndex?: boolean): Promise<Message[] | undefined>;
    /***
     * 本地消息是否已经存在
     */
    hasMsg(conversationId: string, msgUuid: string): Promise<boolean | undefined>;
    /**
     * 插入或更新消息
     * @param message
     * @returns
     */
    insertMessage(message: Message): Promise<boolean>;
    updateMessage(message: Message, updateProperty?: boolean, updateAttachment?: boolean): Promise<boolean>;
    /**
     * 更新消息版本号
     * @param convId
     * @param msgUuid
     * @param msgVersion
     * @returns
     */
    updateMsgVersion(convId: string, msgUuid: string, msgVersion: bigint): Promise<boolean>;
    /**
     * 做一些入库前的拦截操作
     */
    private beforeInsertOrUpdateMessage;
    private computeMsgTableFlag;
    /**
     * 更新消息的localExt内容写入到DB
     * @param message 待更新的消息
     * @returns 操作是否成功
     */
    updateMsgLocalExt(conversationId: string, msgUuid: string, localExtStr: string): Promise<boolean>;
    getLastShowMsg(conversationId: Nullable<string>, isUseThreadPool?: boolean): Promise<Nullable<Message>>;
    /***
     * 获取当前登录用户在给定会话里面发送的最后一条消息
     */
    getLastSendMsg(conversationId: string, convShortId: bigint): Promise<Nullable<Message>>;
    getFirstShowMsgIndex(conversationId: Nullable<string>): Promise<bigint>;
    getLastHintMessage(conversationId: Nullable<string>): Promise<Nullable<Message>>;
    computeUnreadMsgCount(conversationId: string, readIndexV1: bigint): Promise<number>;
    /**
     * 计算两个indexV1之间的消息数
     * @param conversationId
     * @param smallIndexV1
     * @param largeIndexV1
     * @returns
     */
    computeMsgCount(conversationId: string, smallIndexV1: bigint, largeIndexV1: bigint): Promise<number>;
    /**
     * 获取会话内最大的indexV1，包括已删除的消息
     * @param convId
     * @returns
     */
    getMaxIndexV1(convId: string): Promise<bigint>;
    /**
     * 删除会话等场景，需要获取<=minIndexV1的最大orderIndex，用于标定删除会话时刻，会话内最后一条消息的orderIndex
     * 主要是多端同步或再次进入会话的场景
     * @param convId
     * @returns
     */
    getMaxOrderIndex(convId: string, minIndexV1: bigint): Promise<bigint>;
    batchDeleteMsg(convId: string, msgUuidList: string[]): Promise<boolean | undefined>;
    forceDeleteAllMsg(conversationId: string): Promise<boolean>;
    deleteMsgByUuid(convId: string, msgUuid: string): Promise<boolean>;
    /**
     * 将Message写入数据库，需要注意bigint精度丢失的问题，需要通过string做中转
     * @param msg 待写入的消息
     * @returns 返回数据库写入bucket
     */
    buildValues(msg: Message): ValuesBucket;
    buildMessages(resultSet: TaskResultSet): Promise<Message[]>;
    /**
     * 获取会话内最后一条消息的created_time，包括已删除的消息
     * @param conversationId 会话
     * @return 最大的created_time
     */
    getMaxMsgCreatedTime(conversationId: string): Promise<number>;
    /**
     * 查询未读的群主发言消息
     * @param conversation
     * @returns
     */
    makeUnreadGroupOwnerMsg(conversation: Conversation | undefined): Promise<void>;
    makeB2cInfoMsg(conversation: Conversation | undefined): Promise<void>;
    /**
     * 批量标记消息已读
     * @param preReadIndex
     * @param afterReadIndex
     * @param convId
     * @returns 返回<cid，标记已读DBsql的结果>
     */
    markLocalMsgRead(preReadIndex: Nullable<bigint>, afterReadIndex: Nullable<bigint>, ...convId: string[]): Promise<Map<string, boolean>>;
    getMsgByIndexV1(convId: string, indexV1: bigint): Promise<Nullable<Message>>;
    getIndexV2ListByRange(convId: string, range: Range): Promise<bigint[] | undefined>;
    getOrderIndexByIndexV2(convId: string, range: Range, needRangeMaxOrderIndex?: boolean): Promise<bigint>;
    getOrderIndexByIndexInConversation(convId: string, indexInConversation: string): Promise<Nullable<string>>;
    getIndexInConversationByOrderIndex(convId: string, orderIndex: string): Promise<Nullable<string>>;
    /**
     * @param convId
     * @returns 获取会话内最小的orderIndex
     */
    getLegalOldestOrderIndex(convId: string): Promise<bigint>;
    getMinOrderIndex(convId: string): Promise<bigint | undefined>;
    getIndexByIndexV2(convId: string, indexV2: bigint): Promise<bigint>;
    forceDeleteMsgByMinIndex(convId: string, minIndexV1: bigint): Promise<boolean>;
    getMsgListNeedFtsIndex(limit: number): Promise<Message[]>;
    updateMsgListNeedFtsIndex(msgUuidMap: Map<string, string>): Promise<void>;
    updateMsgByParams(params: MsgUpdateParams): Promise<boolean>;
    markUnSendFail(): Promise<boolean>;
}

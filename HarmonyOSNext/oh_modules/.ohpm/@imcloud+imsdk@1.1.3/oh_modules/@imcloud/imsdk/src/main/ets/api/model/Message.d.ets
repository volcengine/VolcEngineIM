import { LocalPropertyItem } from './MessageProperty';
import { im_proto } from '../proto';
import { MsgSource, SendMsgStatus, ServerMessageStatus } from '../const/consts';
import { Conversation } from './Conversation';
import { IIMSdkRandomDepend } from '../depend/IIMSdkRandomDepend';
import { IIMHostEnvDepend } from '../depend/IIMHostEnvDepend';
import { SenderInfo } from './SenderInfo';
import { Attachment } from './Attachment';
export declare const DEFAULT_INDEX_IN_CONVERSATION_V2: bigint;
export declare const LABEL_B2C_INFO = "\u7559\u8D44";
/**
 * https://bytedance.larkoffice.com/wiki/wikcn4eYosDsJRvqykKCGNgKjxg
 * 消息结构
 * orderIndex               :order_in_conversation，会话内用来做消息排序，如果客户端没有该消息，则使用server下发的字段数值；如果客户端本地数据库已有该消息，则使用客户端本地的数值
 * index_in_conversation    :历史产物老混链、不连续自增
 * index_in_conversation_v1 :历史产物, 目前server已经废弃，下发的值无意义（抓接口看都为0）
 * index_in_conversation_v2 :最近会话链、新混链，连续自增，因为服务端接口异步原因不会用它来做本地消息排序
 * sort_order               :会话列表中对会话进行排序，属于Conversation维度，统一写在这里用于对比
 *
 * 理解orderIndex：
 * 1. 设计出来完全就是为了处理在多进程网络环境下，不同客户端收发消息的时序问题，统一通过orderIndex来做消息在客户端的排序
 * 2. 之所以能做到这一点，是orderIndex=index_in_conversation * 1000实现的，这样server有1000的buffer处理客户端的消息收发，然后算出新发消息的index_in_conversation并赋值于该新消息
 * 3. 按照第2点算法逻辑，server会得到一个新的orderIndex，但客户端为了避免server算出的orderIndex与客户端本地不一致导致该消息突然的排序变化、位置跳动等ui问题，会保持使用本地生成的orderIndex。只有等到客户端清除本地数据才会使用server下发的orderIndex
 * 4. 最后补充一句，因为orderIndex是基于index_in_conversation * 1000算出来的，而index_in_conversation不连续，因此orderIndex也不连续
 *
 * 理解index_in_conversation:
 * 1. 是一个递增但不连续的int64数值，是一个很大的数值（长度类似于时间戳，但不是时间戳），是server用来标记消息在单链上的位置及排序。orderIndex=index_in_conversation*1000
 *
 * 理解index_in_conversation_v2:
 * 1. 由于客户端需要确保给用户展示的消息是完整的，因此需要引入连续的index_in_conversation_v2来判断消息列表是否有缺失的消息
 * 2. index_in_conversation_v2是通过index_in_conversation计算出来的，从1开始递增
 */
export declare class Message {
    /**
     * orderIndex
     */
    orderIndex: bigint;
    /**
     * 消息的 msg Id, 或称 msg server_id，string 形式的一个 int64
     */
    msgId: bigint;
    /**
     * 消息类型
     */
    msgType: number;
    /**
     * 消息所属会话 id
     * {@link Conversation.id}
     */
    conversationId: string;
    /**
     * 消息所属会话 short id
     * {@link Conversation.shortId}
     */
    conversationShortId: bigint;
    /**
     * 消息所属会话类型
     * @{link Conversation.type}
     */
    conversationType: number;
    /**
     * uuid
     */
    uuid: string;
    /**
     * 消息发送方 uid
     */
    sender: bigint;
    /**
     * 消息发送者信
     */
    senderInfo: SenderInfo | undefined;
    /**
     * 消息发送方加密 uid
     */
    secSender: string;
    /**
     * 消息创建时间
     */
    createdAt?: number;
    /**
     * 消息内容
     */
    content: string;
    contentByte: Uint8Array | undefined;
    /**
     * 消息会话内容部的index
     */
    indexInConversation: bigint;
    /**
     * indexInConversationV2
     */
    indexInConversationV2: bigint;
    /**
     * 消息版本号
     */
    version: bigint;
    /**
     * 是否已删除
     */
    deleted: number;
    /**
     * 消息状态
     */
    serverStatus: ServerMessageStatus;
    /**
     * 消息发送状态
     */
    msgStatus: SendMsgStatus;
    /**
     * 消息状态
     */
    messageStatus: im_proto.MessageStatus;
    /**
     * 消息已读状态
     */
    readStatus: number;
    /**
     * rowid
     */
    rowid: bigint;
    /**
     * 消息 ext 字段
     */
    ext: Map<string, string>;
    /**
     * 消息 localExt 字段
     */
    localExt: Map<string, string>;
    /**
     * property
     */
    property: Map<string, LocalPropertyItem[]>;
    /**
     * 消息所带附件
     */
    attachments: Attachment[];
    /**
     * 消息引用
     */
    referenceInfo?: im_proto.IReferenceInfo | undefined;
    /**
     * 利用本字段的二进制位做标志位
     */
    tableFlag: bigint;
    /**
     * 用来标记是否需要建立FTS索引
     */
    needBuildFtsIndex: number;
    /**
     * labelListStr
     */
    labelListStr: string;
    /**
     * 该会话所有标签
     */
    labelSet: Set<string>;
    /**
     * source
     */
    source: MsgSource;
    get localExtStr(): string;
    set localExtStr(str: string);
    get extStr(): string;
    set extStr(str: string);
    /**
     * 消息客户端 id
     */
    get clientId(): string;
    set clientId(value: string);
    getRefMsgId(): bigint | -1;
    setRefMsgId(msgId: string): void;
    /**
     * 设置引用的消息数据
     * @param referenceInfo
     */
    setRefMsg(referenceInfo: im_proto.IReferenceInfo): void;
    /**
     * 是否是一条普通消息, 区别于 Command 这种特殊消息
     * @returns
     */
    get isNormalMsg(): boolean;
    /**
     * 是否是一条命令消息 (type === 50001) https://bytedance.feishu.cn/wiki/wikcn4eYosDsJRvqykKCGNgKjxg#sZU956
     * @returns
     */
    get isCommandMsg(): boolean;
    /**
     * 是否是一条特殊消息 (type >= 50000)
     * @returns
     */
    get isSpecialMessage(): boolean;
    get isSuccessOrNormal(): boolean;
    get isSelfRead(): boolean;
    /**
     * 消息是否被撤回
     * @returns
     */
    get isRecalled(): boolean;
    /**
     * 消息里包含的被 @ 用户
     * @returns
     */
    get mentionedUserIds(): bigint[];
    set mentionedUserIds(v: bigint[]);
    get isStrangerMessage(): boolean;
    get isDeleted(): boolean;
    /**
     * @return 消息已经被编辑过的次数, 默认返回0
     */
    getEditCount(): number;
    /**
     * 按照orderIndex或createAtTime顺序排列
     * 降序/逆序：离输入框最近的消息排在数组的前面
     * 顺序：离屏幕顶部最近的消息排在数组的后面
     * @param a
     * @param b
     * @returns
     */
    static compareToAsc(a: Message, b: Message): number;
    /**
     * 按照orderIndex或createAtTime降序排列
     * 降序/逆序：离输入框最近的消息排在数组的前面
     * 顺序：离屏幕顶部最近的消息排在数组的后面
     * @param a
     * @param b
     * @returns
     */
    static compareToDesc(a: Message, b: Message): number;
}
/**
 * Builder
 */
export declare class MessageBuilder {
    private readonly msg;
    private readonly randomDepend;
    private readonly hostEnvDepend;
    constructor(randomDepend: IIMSdkRandomDepend, hostEnvDepend: IIMHostEnvDepend);
    conversationId(conversationId: string): this;
    conversation(conversation: Conversation): this;
    convAddToHead(conversation: Conversation): this;
    p2pInfo(conversation: Conversation): this;
    msgType(msgType: number): this;
    content(content: string): this;
    localExt(ext: Map<string, string>): this;
    uid(uid: bigint): this;
    secUid(secUid: string): this;
    build(): Message;
}

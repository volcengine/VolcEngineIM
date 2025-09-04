import { im_proto } from '../proto';
import { ConversationStatus, StickTopState, ConversationChangeReason } from '../const/consts';
import { ConversationCoreInfo } from './ConversationCoreInfo';
import { ConversationSettingInfo } from './ConversationSettingInfo';
import { Message } from './Message';
import { Member } from './Member';
import { IMSdkContext } from '../../client/IMSdkContext';
import { TopMessageModel } from './TopMessageModel';
/** 会话结构 */
export declare class Conversation {
    /**
     * 会话 id, 单聊 id 规则为 `{inboxType}:1:{minUid}:{maxUid}`, 群聊为 short id
     */
    conversationId: string;
    /**
     * 会话 short id, 一个 int64
     */
    conversationShortId: bigint;
    /**
     * conversationType
     */
    conversationType: number;
    /**
     * 是否是会话的成员
     */
    isMember: boolean;
    /**
     * 会话成员总数 (缓存态, 不实时)
     */
    memberCount: number;
    /**
     * updatedTime
     */
    updatedTime: number;
    /**
     * 会话排序用的时间戳
     */
    orderTimestamp: number;
    /**
     * 后一条消息，不等于lastShowMessage 的 index
     * 没有过滤掉被删除，不显示的消息
     */
    lastMessageIndex: bigint;
    /**
     * lastShowMessageUuid
     */
    lastShowMessageUuid: string;
    /**
     * 判断未读数是否需要降级的时间戳，一般情况下与lastMessage的createdAt相等，但是不上浮的消息不会更新该时间戳
     */
    unreadDemoteTime: number;
    /**
     * lastMessageOrderIndex
     */
    lastMessageOrderIndex: bigint;
    /** ticket */
    ticket: string;
    /**
     * 默认hasMore是true，需要拉一次接口才知道是否拉完
     */
    hasMore: boolean;
    /**
     * 会话状态
     * {@link ConversationStatus}
     */
    status: ConversationStatus;
    /**
     * 本地数据：草稿修改时间
     */
    draftTime: number;
    /**
     * 本地数据：草稿内容
     */
    draftContent: string;
    /**
     * 用于会话列表的排序，从大到小
     */
    sortOrder: number;
    /**
     * 本地数据：ext字段
     * 非必需使用此字段可以考虑使用 localKv 代替
     * Slardar: https://t.wtturl.cn/Dr2mtMD/
     */
    localExt: Map<string, string>;
    /**
     * 本地持久化，保存在 conversation_kv
     */
    localKV: Map<string, string>;
    /**
     * 该字段是从另一张表里获取的数据
     *
     * @see // com.bytedance.im.core.internal.db.IMConversationMemberDao
     */
    memberIds?: bigint[];
    /**
     * 最后一条消息，不等于lastMessageIndex的数据
     * 过滤掉被删除，不显示的消息后的最后一条消息
     * 非数据库字段，需要初始化时，从DB加载出该字段
     */
    lastMessage?: Message;
    /**
     * 用于计算sortOrder的消息，大多数情况下等于lastMessage，当满足Tips不上浮条件时不等于lastMessage，
     * 文档：https://bytedance.feishu.cn/wiki/wikcniVwVkC7C9AYgOlat4OKSgg#mYCC2S
     */
    sortOrderMessage?: Message;
    /**
     * 未读的别人@你的消息
     * 非数据库字段，需要初始化时，从DB加载出该字段
     */
    unreadSelfMentionedMessages?: Nullable<Message[]>;
    /**
     * 未读的群主发言, Nullable
     */
    unreadGroupOwnerMessages?: Nullable<Message[]>;
    /**
     * 会话的 Core 信息
     */
    coreInfo: ConversationCoreInfo | undefined;
    /**
     * 会话的 Setting 信息
     */
    settingInfo?: ConversationSettingInfo;
    /**
     * 会话中当前成员的信息
     */
    member?: Member;
    /**
     * 当前用户在这个会话的角色, 配合conversation_type使用
     */
    role: number;
    /**
     * 单聊会话的双方成员信息，群聊为空
     */
    singleChatMembers?: Member[];
    /**
     * isStranger
     */
    isStranger: boolean;
    /**
     * 创作者私信优化
     */
    isInStrangerBox: boolean;
    /**
     * strangerVersion
     */
    strangerVersion: bigint;
    /**
     * isInBox
     */
    isInBox: boolean;
    /**
     * isFolded
     */
    isFolded: boolean;
    /**
     * deleted
     */
    deleted: number;
    /**
     * deleteTime
     */
    deleteTime: number;
    /**
     * 会话最小index_v2
     */
    minIndexV2: bigint;
    /**
     * 当前会话读过的消息数目（只计算未读的消息数目），只增不减
     */
    readBadgeCount: number;
    /**
     * 当前会话可读的消息数目（只计算未读消息数目），只增不减
     */
    badgeCount: number;
    /**
     * 如果true代表是由DB组装，各项数据为最新可信任，如果是false代表从内存中拿，数据可能不是最新
     */
    fromDB: boolean;
    /**
     * 业务未读数
     */
    bizUnreadCount: number;
    /**
     * b2c留咨消息
     */
    b2cInfoMessage?: Nullable<Message>;
    /**
     * 最后一条外显消息
     */
    lastHintMessage?: Message;
    /**
     * 最后一条外显消息的uuid
     * null表示会话没有更新过lastHintMessage
     * ""表示回话没有lastHintMessage
     */
    lastHintMessageUuid?: string;
    /**
     * 当前用户发起或者参与的且已经成功合成的群合拍消息
     */
    shootTogetherMsgIds?: bigint[];
    /**
     * 用于会话个数达到上线，根据lru策略淘汰会话，以保证内存健康
     */
    recentLruTs: bigint;
    /**
     * muteBadgeCountInfos
     */
    muteBadgeCountInfos: im_proto.IMuteBadgeCountInfo[];
    /**
     * 第一页会话成员列表
     */
    firstPageParticipant?: im_proto.IParticipantsPage;
    /**
     * 置顶消息
     */
    topMessageModel: TopMessageModel[];
    /**
     * 会话是否是离线状态 (未从服务端拉取完整信息)
     */
    isOffline: boolean;
    /**
     * 未读数
     */
    unreadCount: number;
    /**
     * 群聊机器人 todo liujia.aaron 实现
     */
    groupBots: string[];
    /**
     * 会话最大index_v2，只增不减（不一定为lastMessage.indexInConversationV2）
     */
    private _maxIndexV2;
    private _inboxType;
    private _readIndex;
    private _readIndexV2;
    private _minIndex;
    /**
     * 飞鸽中服务端的最大index
     */
    maxIndexV2FromServer: bigint;
    /**
     * 控制 label 是否需要清洗数据的 version
     */
    labelVersion: number;
    /**
     * labelListStr
     */
    _labelListStr: string;
    /**
     * 该会话所有标签
     */
    _labelSet?: Set<string>;
    /**
     * 在线人数，仅支持直播群
     */
    onlineMemberCount: number;
    /**
     * 只读的属性
     */
    /**
     * 会话所在的 InboxType
     * @returns
     */
    get inboxType(): number;
    set inboxType(inboxType: number);
    get labelListStr(): string;
    /**
     * sdk内部使用
     * @param str
     */
    set labelListStr(str: string);
    /***
     * 业务使用
     */
    get labelSet(): Set<string>;
    /**
     * 会话是否置顶
     * {@link StickTopState}
     */
    get isStickOnTop(): boolean;
    get getStickTop(): StickTopState;
    /**
     * 会话是否被收藏
     * {@link FavoriteState}
     */
    get isFavorite(): boolean;
    /**
     * 获得会话的 ext
     */
    get ext(): Map<any, any>;
    /**
     * 是否为本地构建的会话
     */
    get isLocal(): boolean;
    get isDeleted(): boolean;
    /**
     * 从map转为string
     * @returns
     */
    get localExtStr(): string;
    /**
     * 是否为单聊
     * @returns
     */
    get isSingleChat(): boolean;
    /**
     * 是否为群聊
     * @returns
     */
    get isGroupChat(): boolean;
    /**
     * 设置localExtStr，同步转为localExtMap
     * @param localExtStr
     */
    set localExtStr(localExtStr: string);
    /**
     * readIndex
     */
    get readIndex(): bigint;
    set readIndex(readIndex: bigint);
    /**
     * readIndexV2
     * @returns
     */
    get readIndexV2(): bigint;
    set readIndexV2(readIndexV2: bigint);
    /**
     * minIndex
     * @returns
     */
    get minIndex(): bigint;
    set minIndex(minIndex: bigint);
    /**
     * 会话 Setting 版本
     * @returns
     */
    get version(): bigint;
    get maxIndexV2(): bigint;
    set maxIndexV2(maxIndexV2: bigint);
    get memberStr(): string;
    set memberStr(memberStr: string);
    get unreadCountFromReadBadge(): number;
    /**
     * 获得最后一条消息的创建时间
     * 暂时作为会话的显示更新时间
     * 如果没有消息, 返回0
     */
    get updatedAt(): number;
    /**
     * 会话是否免打扰
     */
    get isMute(): boolean;
    /**
     * 获取业务维度会话标签
     */
    get tagIds(): string[];
    /**
     * 获取用户维度会话标签
     */
    get userTagIds(): string[];
    set dissolved(dissolved: number);
    get isDissolved(): boolean;
    set displayed(displayed: number);
    get isDisplayed(): boolean;
    get isTemp(): boolean;
    /**
     * 按照sortOrder降序排序
     * 在靠近手机屏幕顶部的位置sortOrder最大
     * @param a
     * @param b
     * @returns
     */
    static compareTo(a: Conversation, b: Conversation): number;
    static setLegalUid(thisObj: Conversation, uid: string): void;
    /**
     * @return 从老版本更新到新版本后，read_badge_count是否有更新过，如果没更新过，需要更新下，防止read_badge_count偏小。
     */
    static isReadBadgeCountUpdated(thisObj: Conversation): boolean;
    static isWaitingInfo(thisObj: Conversation): boolean;
    static getSkipMuteBadgeCountInfos(thisObj: Conversation): im_proto.IMuteBadgeCountInfo[];
    static getUnreadSkipMuteCount(thisObj: Conversation): Nullable<string>;
    static getSkipMuteBadgeCountInfo(thisObj: Conversation, type: im_proto.MuteMessageType): Nullable<im_proto.IMuteBadgeCountInfo>;
    static isLastHintMessageUpdated(thisObj: Conversation): boolean;
    /**
     * 单聊会话的对方用户, 返回对方 uid
     * {@link toParticipant}
     */
    static getParticipantUserId(ctx: IMSdkContext, conv: Conversation): string;
    static removeMentionMessage(thisObj: Conversation, msgUuid: string): boolean;
}
/**
 * 设计时考虑的背景：
 * 1. 一个会话的变更通知，携带多个具体的会话字段变更
 *  因此设计了updateChangeReasons，存储的key为会话id、value为本次通知的会话的所有变更
 *
 * 2. 可能会有多个会话触发变更
 *  因此设计了withMultiConversations用于通知多个会话的变更情况
 * @see BatchUpsertConversationSettingExtHandler
 *
 * 上层业务可以通过isBatchConversationUpdate来判断这种多会话or多变更点情况，处理多个会话、多个变更的情况
 *
 * 目前只有BatchUpsertConversationSettingExtHandler这一个场景
 *
 * 其他99%的场景，都是单一会话、单一变更点通知回调
 *
 */
export declare class UpdateConversationInfo {
    updateFrom: string;
    needUpdateLastMsgUuid?: boolean;
    withUnreadUpdate?: boolean;
    withOneConversation?: Nullable<Conversation>;
    isBatchConversationUpdate?: Nullable<boolean>;
    withMultiConversations?: Nullable<Conversation[]>;
    updateChangeReason?: Nullable<ConversationChangeReason>;
    updateChangeReasons?: Nullable<Map<string, ConversationChangeReason[]>>;
    /**
     * 快捷方法：提供会话变更的原因，因为有可能存在多种变更原因，所以为数组结构
     * @param convId
     * @returns
     */
    static getUpdateReasonList(info: UpdateConversationInfo, convId: string): ConversationChangeReason[];
}

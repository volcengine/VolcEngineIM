import { IMAccessor } from '@imcloud/imsdk_common';
import { ExpandService } from '@imcloud/imsdk_common/src/main/ets/api/ExpandService';
import { BIMLiveGroupListResult, IMSdkClient, BIMConversation, BIMGroupInfo, BIMLiveMessageListResult, BIMLiveJoinGroupResult, MemberUpdateInfo, BIMLiveGroupMemberEventListener, BIMLiveConversationListener, BIMMessage, BIMLiveMessageListener, BIMMessagePriority, BIMSendCallback } from '../../../../../../Index';
import { BIMResult } from '../../../bim/api/model/BIMResult';
import { LiveLifeManager } from '../../life/LiveLifeManager';
import { BIMLiveMemberListResult } from '../model/BIMLiveMemberListResult';
import { BIMLiveMemberOnlineInfo } from '../model/BIMLiveMemberOnlineInfo';
/**
 * @detail api
 * @brief IM SDK 直播群对外接口类，通过此类提供所有直播群能力接口。
 * @note 获取实例方式 通过BIMClient提供的接口getLiveService()，参看 BIMClient{@link #BIMClient}，直播群不提供本地数据存储。
 * @list overview
 */
export declare class BIMLiveExpandService implements ExpandService {
    private TAG;
    private sdkContext;
    private liveGroupMap;
    private messageListenerList;
    private markTypeListenerList;
    private conversationListenerList;
    private memberEventListenerList;
    private bimClient;
    private logger;
    private connectListener;
    /** @hidden */
    constructor(sdkClient: IMSdkClient);
    /** @hidden */
    log(content: string): void;
    /** @hidden */
    onConfigReady(json: string): void;
    /** @hidden */
    init(context: Context, imAccessor: IMAccessor): void;
    /** @hidden */
    unInit(context: Context): void;
    /** @hidden */
    onLogin(context: Context, uid: bigint): void;
    /** @hidden */
    onLogout(): void;
    /**
     * @param listener 直播群消息事件回调监听方，参看 BIMLiveMessageListener{@link #BIMLiveMessageListener}。
     * @detail api
     * @brief 设置直播群消息监听。
     * @group liveGroup
     * @order 0
     */
    addLiveGroupMessageListener(listener: BIMLiveMessageListener): void;
    /**
     * @param listener 直播群消息事件回调监听方，参看 BIMLiveMessageListener{@link #BIMLiveMessageListener}。
     * @detail api
     * @brief 设置直播群消息监听。
     * @group liveGroup
     * @order 1
     */
    removeLiveGroupMessageListener(listener: BIMLiveMessageListener): void;
    /**
     * @param listener 直播群会话事件回调监听方，参看 BIMLiveConversationListener{@link #BIMLiveConversationListener}。
     * @detail api
     * @brief 设置直播群会话监听。
     * @group liveGroup
     * @order 2
     */
    addLiveConversationListener(listener: BIMLiveConversationListener): void;
    /**
     * @param listener 直播群会话事件回调监听方，参看 BIMLiveConversationListener{@link #BIMLiveConversationListener}。
     * @detail api
     * @brief 移除直播群会话监听。
     * @group liveGroup
     * @order 3
     */
    removeLiveConversationListener(listener: BIMLiveConversationListener): void;
    /**
     * @param listener 直播群成员事件回调监听方，参看 BIMLiveGroupMemberEventListener{@link #BIMLiveGroupMemberEventListener}。
     * @detail api
     * @brief 设置直播群成员监听。
     * @group liveGroup
     * @order 4
     */
    addLiveGroupMemberListener(listener: BIMLiveGroupMemberEventListener): void;
    /**
     * @param listener 直播群成员事件回调监听方，参看 BIMLiveGroupMemberEventListener{@link #BIMLiveGroupMemberEventListener}。
     * @detail api
     * @brief 移除直播群成员监听。
     * @group liveGroup
     * @order 5
     */
    removeLiveGroupMemberListener(listener: BIMLiveGroupMemberEventListener): void;
    /**
     * @param cursor   分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextCursor。
     * @param count    分页拉取的个数。一次分页拉取不宜太多，否则可能影响拉取的速度，建议每次拉取 20 个会话。
     * @param callback 结果回调，参看 BIMResult{@link #BIMResult}, BIMLiveGroupListResult{@link #BIMLiveGroupListResult}。
     * @detail api
     * @brief 获取我是群主和管理员的直播群列表。
     * @group liveGroup
     * @order 6
     */
    getOwnerLiveGroupList(cursor: number, count: number): Promise<BIMResult<BIMLiveGroupListResult>>;
    /**
     * @param cursor   分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextCursor。
     * @param count    分页拉取的个数。一次分页拉取不宜太多，否则可能影响拉取的速度，建议每次拉取 20 个会话。
     * @param callback 结果回调，参看 BIMResult{@link #BIMResult}, BIMLiveGroupListResult{@link #BIMLiveGroupListResult}。
     * @detail api
     * @brief 获取当前应用下的所有直播群列表。
     * @group liveGroup
     * @order 7
     */
    getAllLiveGroupList(cursor: number, count: number): Promise<BIMResult<BIMLiveGroupListResult>>;
    /**
     * @param groupInfo 创建直播群参数信息，包括名称，头像等，参看 BIMGroupInfo{@link #BIMGroupInfo}。
     * @param callback  结果回调，参看 BIMResult{@link #BIMResult}, BIMConversation{@link #BIMConversation}。
     * @detail api
     * @brief 创建直播群。
     * @group liveGroup
     * @order 8
     */
    createLiveGroup(groupInfo: BIMGroupInfo): Promise<BIMResult<BIMConversation | undefined>>;
    /**
     * @param conversationShortId 直播群会话 shortId。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}, BIMConversation{@link #BIMConversation}。
     * @detail api
     * @brief 获取直播群信息。
     * @group liveGroup
     * @order 9
     */
    getLiveGroup(conversationShortId: string): Promise<BIMResult<BIMConversation | undefined>>;
    /**
     * @param conversationShortId 直播群会话 shortId。
     * @param cursor              直播群历史消息拉取起点
     * @param callback            获取直播群历史消息，参看 BIMResult{@link #BIMResult},BIMLiveMessageListResult{@link #BIMLiveMessageListResult}。
     * @detail api
     * @brief 获取直播群历史消息(从新到旧)。
     * @group liveGroup
     * @order 10
     */
    getLiveGroupHistoryMessageList(conversationShortId: string, cursor: number, limit: number): Promise<BIMResult<BIMLiveMessageListResult>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}, BIMLiveJoinGroupResult{@link #BIMLiveJoinGroupResult}。
     * @detail api
     * @brief 加入直播群，加入直播群后可以收发当前群的信息，直播群不提供本地存储。
     * @group liveGroup
     * @order 11
     */
    joinLiveGroup(conversationShortId: string): Promise<BIMResult<BIMLiveJoinGroupResult | undefined>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param memberInfo          当前用户成员信息，参看 MemberUpdateInfo{@link #MemberUpdateInfo}。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}, BIMLiveJoinGroupResult{@link #BIMLiveJoinGroupResult}。
     * @detail api
     * @brief 加入直播群并设置当前用户成员信息。
     * @notes <br>
     * + 同一时间只能进入一个直播群，直播群不提供本地存储。
     * + 成员信息与用户信息不同，用户在不同直播群可以拥有不同的成员信息，退群后信息自动销毁。
     * @group liveGroup
     * @order 12
     */
    joinLiveGroupWithInfo(conversationShortId: string, memberInfo: MemberUpdateInfo | undefined): Promise<BIMResult<BIMLiveJoinGroupResult | undefined>>;
    /**
     * @hidden
     */
    private joinLiveGroupInner;
    /**
     * @param message      发送的消息体，参看 BIMMessage{@link #BIMMessage}。
     * @param conversation 会话信息，参看 BIMConversation{@link #BIMConversation}。
     * @param priority     设置消息优先级，参看 BIMMessagePriority{@link #BIMMessagePriority}。
     * @param callback     结果回调，参看 BIMSendCallback{@link #BIMSendCallback}。
     * @detail api
     * @brief 发送直播群消息。
     * @group liveGroup
     * @order 13
     */
    sendLiveGroupMessage(message: BIMMessage, conversation: BIMConversation, priority: BIMMessagePriority, sendCallback: BIMSendCallback | undefined): void;
    /**
     * @hidden
     */
    private isFileSizeValid;
    /**
     * @hidden
     */
    private sendLiveMediaMessage;
    /**
     * @hidden
     */
    getLifeManger(conversationShortId: string): LiveLifeManager | undefined;
    /**
     * @hidden
     */
    private sendLiveMessageInner;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 离开直播群。
     * @group liveGroup
     * @order 14
     */
    leaveLiveGroup(conversationShortId: string): Promise<BIMResult<boolean>>;
    /**
     * @param bimMessage 消息体，参看 BIMMessage{@link #BIMMessage}。
     * @param callback   结果回调，参看 BIMResult{@link #BIMResult}, BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 刷新直播群媒体信息，媒体 URL 过期时调用该方法。
     * @group liveGroup
     * @order 15
     */
    refreshLiveGroupMediaMessage(bimMessage: BIMMessage): Promise<BIMResult<Nullable<BIMMessage>>>;
    /**
     * @param conversationShortId 直播群会话 shortId。
     * @param callback            在线人数结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 获取直播群在线人数。
     * @group liveGroup
     * @order 16
     */
    getLiveGroupOnLineCount(conversationShortId: string): Promise<BIMResult<number>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 解散直播群，仅群主可操作。
     * @group liveGroup
     * @order 17
     */
    dissolveLiveGroup(conversationShortId: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param cursor              分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextCursor。
     * @param count               分页拉取的个数。一次分页拉取不宜太多，否则可能影响拉取的速度，建议每次拉取 20 成员。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}, BIMLiveMemberListResult{@link #BIMLiveMemberListResult}。
     * @detail api
     * @brief 获取直播群在线用户列表。
     * @notes <br>
     * + 使用国内环境时，支持拉取最新加群的 10,000 个在线成员。
     * + 使用海外环境时，支持拉取最新加群的 3,000 个在线成员。
     * @group liveGroup
     * @order 18
     */
    getLiveGroupMemberOnlineList(conversationShortId: string, cursor: number, limit: number): Promise<BIMResult<BIMLiveMemberListResult>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param cursor              分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextCursor。
     * @param count               分页拉取的个数。一次分页拉取不宜太多，否则可能影响拉取的速度，建议每次拉取 20 成员。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}, BIMLiveMemberListResult{@link #BIMLiveMemberListResult}。
     * @detail api
     * @brief 获取直播群群主管理员等常驻成员列表。
     * @group liveGroup
     * @order 19
     */
    getLiveGroupMemberList(conversationShortId: string, cursor: number, limit: number): Promise<BIMResult<BIMLiveMemberListResult>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param cursor              分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextCursor。
     * @param count               分页拉取的个数。一次分页拉取不宜太多，否则可能影响拉取的速度，建议每次拉取 20 成员。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}, BIMLiveMemberListResult{@link #BIMLiveMemberListResult}。
     * @detail api
     * @brief 获取会话禁言白名单。
     * @group liveGroup
     * @order 20
     */
    getLiveGroupMemberSilentWhiteList(conversationShortId: string, cursor: number, limit: number): Promise<BIMResult<BIMLiveMemberListResult>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             成员列表
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 添加禁言会话白名单。
     * @group liveGroup
     * @order 21
     */
    addLiveGroupMemberSilentWhiteList(conversationShortId: string, uidList: string[]): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             成员列表
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 移除禁言会话白名单。
     * @group liveGroup
     * @order 22
     */
    removeLiveGroupMemberSilentWhiteList(conversationShortId: string, uidList: string[]): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param cursor              分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextCursor。
     * @param count               分页拉取的个数。一次分页拉取不宜太多，否则可能影响拉取的速度，建议每次拉取 20 成员。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult},BIMLiveMemberListResult{@link #BIMLiveMemberListResult}。
     * @detail api
     * @brief 获取直播群进群黑名单。
     * @group liveGroup
     * @order 23
     */
    getLiveGroupMemberBlockList(conversationShortId: string, cursor: number, count: number): Promise<BIMResult<BIMLiveMemberListResult>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             待加入禁言成员 UID 列表。
     * @param blockTime           禁言时间(绝对时间), 单位: 秒(s)
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 添加群进群黑名单。
     * @group liveGroup
     * @order 24
     */
    addLiveGroupMemberBlockList(conversationShortId: string, uidList: string[], blockTime: number): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             待移出禁言成员 UID 列表。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 移除群进群黑名单。
     * @group liveGroup
     * @order 25
     */
    removeLiveGroupMemberBlockList(conversationShortId: string, uidList: string[]): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param cursor              分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextCursor。
     * @param count               分页拉取的个数。一次分页拉取不宜太多，否则可能影响拉取的速度，建议每次拉取 20 成员。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult},BIMLiveMemberListResult{@link #BIMLiveMemberListResult}。
     * @detail api
     * @brief 获取直播群禁言用户列表。
     * @group liveGroup
     * @order 26
     */
    getLiveGroupMemberSilentList(conversationShortId: string, cursor: number, count: number): Promise<BIMResult<BIMLiveMemberListResult>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param isSilent            禁言设置为 true、取消禁言设置为 false。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}, BIMLiveMemberListResult{@link #BIMLiveMemberListResult}。
     * @detail api
     * @brief 设置会话禁言(所有成员禁言)。
     * @group liveGroup
     * @order 27
     */
    setLiveGroupSilent(conversationShortId: string, isSilent: boolean): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             待添加禁言成员 UID 列表。
     * @param blockTime           禁言时间(绝对时间), 单位: 秒(s)
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 添加群成员禁言。
     * @group liveGroup
     * @order 28
     */
    addLiveGroupMemberSilentList(conversationShortId: string, uidList: string[], blockTime: number): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             待添加禁言成员 UID 列表。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 移出群成员禁言。
     * @group liveGroup
     * @order 29
     */
    removeLiveGroupMemberSilentList(conversationShortId: string, uidList: string[]): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             踢出成员 UID 列表。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 踢出在线成员。
     * @group liveGroup
     * @order 30
     */
    kickLiveGroupMemberList(conversationShortId: string, uidList: string[]): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uid                 转让群主用户 ID。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 转让群主。
     * @group liveGroup
     * @order 31
     */
    transLiveGroupOwner(conversationShortId: string, uid: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             设置群管理员列表
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 设置直播群管理员。
     * @group liveGroup
     * @order 32
     */
    addLiveGroupAdmin(conversationShortId: string, uidList: string[]): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             移除群管理员列表
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 移除直播群管理员。
     * @group liveGroup
     * @order 33
     */
    removeLiveGroupAdmin(conversationShortId: string, uidList: string[]): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uidList             设置成员列表
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 设置成员角色。
     * @group liveGroup
     * @order 34
     */
    setLiveGroupMemberRole(conversationShortId: string, uidList: string[], uidStrList: string[], role: number): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param memberInfo          设置当前用户成员信息，参看 MemberUpdateInfo{@link #MemberUpdateInfo}。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @notes 成员信息与用户信息不同，用户在不同直播群可以拥有不同的成员信息，退群后信息自动销毁。
     * @brief 设置直播群成员信息，覆盖服务端存储。
     * @group liveGroup
     * @order 35
     */
    setLiveGroupMemberInfo(conversationShortId: string, memberInfo: MemberUpdateInfo): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param alias               设置当前用户成员昵称。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 设置直播群成员昵称。
     * @group liveGroup
     * @order 36
     */
    setLiveGroupMemberAlias(conversationShortId: string, alias: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param avatarUrl           设置当前用户成员头像 URL。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 设置直播群成员头像。
     * @group liveGroup
     * @order 37
     */
    setLiveGroupMemberAvatar(conversationShortId: string, avatarUrl: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param ext                 设置直播群成员自定义信息。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 设置直播群成员自定义信息，相同 key 会覆盖。
     * @group liveGroup
     * @order 38
     */
    addLiveGroupMemberExt(conversationShortId: string, ext: Map<string, string>): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param uid                 直播群成员 uid
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}, BIMLiveJoinGroupResult{@link #BIMLiveJoinGroupResult}。
     * @detail api
     * @brief 获取直播群成员信息，其中包括当前在直播群的成员以及群主管理员，退出群的游客信息无法获取。
     * @group liveGroup
     * @order 39
     */
    getLiveGroupMemberInfo(conversationShortId: string, uid: string): Promise<BIMResult<BIMLiveMemberOnlineInfo | undefined>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param notice              群公告。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 设置群公告。
     * @group liveGroup
     * @order 40
     */
    setLiveGroupNotice(conversationShortId: string, notice: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param description         群描述。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 设置群描述。
     * @group liveGroup
     * @order 41
     */
    setLiveGroupDescription(conversationShortId: string, desc: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param name                群名称。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 设置群名称。
     * @group liveGroup
     * @order 42
     */
    setLiveGroupName(conversationShortId: string, name: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId 直播群 ShortId。
     * @param url                 群头像 URL。
     * @param callback            结果回调，参看 BIMResult{@link #BIMResult}。
     * @detail api
     * @brief 设置群头像。
     * @group liveGroup
     * @order 43
     */
    setLiveGroupIcon(conversationShortId: string, icon: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param uidList        成员 ID 列表。
     * @param callback       结果回调， 参看 BIMLiveMemberOnlineInfo{@link #BIMLiveMemberOnlineInfo}
     * @detail api
     * @brief 获取直播群成员在线信息。
     * @group liveGroup
     * @order 44
     */
    getLiveGroupMemberOnlineInfo(conversationShortId: string, uidList: string[]): Promise<BIMResult<BIMLiveMemberOnlineInfo[]>>;
    /**
     * @hidden
     */
    private p_getLiveGroupMemberBlockList;
}

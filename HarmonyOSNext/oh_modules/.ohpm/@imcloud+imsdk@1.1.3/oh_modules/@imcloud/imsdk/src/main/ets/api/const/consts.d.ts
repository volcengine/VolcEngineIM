import { im_proto } from '../proto';
export declare const INVALID_UID = -1;
export declare const BIG_MAX_VALUE: bigint;
export declare const BIG_MIN_VALUE: bigint;
export declare const BIG_NEG_ONE: bigint;
export declare const BIG_ZERO: bigint;
export declare const BIG_ONE: bigint;
export declare const MIN_SERVER_INDEX_IN_CONVERSATION = 10000000;
export declare const STRING_MAX_VALUE: string;
export declare const BASE_INDEX_V2: bigint;
export declare const MAX_SQL_IN_SIZE = 500;
export declare const STRING_ZERO = "0";
export declare const EMPTY_STR = "";
export declare enum ConversationUpdateReason {
    UNKNOWN = 0,
    ADD_MEMBER = 1,
    MSG_UPDATE = 2,
    MARK_READ = 3,
    LEAVE_CONVERSATION = 4,
    REFRESH_INFO = 5,
    CREATE_TEMP = 6,
    LOAD_MEMBER = 7,
    REMOVE_MEMBER = 8,
    DRAFT_CHANGE = 9,
    LOCAL_EXT_CHANGE = 10,
    HAS_MORE_CHANGE = 11,
    LOCAL_KV_CHANGE = 12,
    LABEL_CHANGE = 13,
    ADD_BOT = 14,
    REMOVE_BOT = 15,
    EXCHANGE_END = 16
}
export declare enum NetType {
    /**
     * SDK自动切换，优先走长链，失败后使用短链
     */
    AUTO = 0,
    /**
     * 只使用长链
     */
    WS = 1,
    /**
     * 只使用短链
     */
    HTTP = 2
}
/**
 * IMSDK初始化链初始化状态
 */
export declare enum IMInitResult {
    INIT_START = 0,
    INIT_ERROR = 1,
    INIT_SUCCESS = 2,
    INIT_ALREADY = 3
}
export declare enum HttpContentType {
    PB = 0,
    JSON = 1
}
export declare enum HttpBodyMode {
    BYTE = 0,
    OBJECT = 1
}
export declare enum BDNetworkTagTriggerType {
    AUTO = 0,
    MANUAL = 1
}
export declare enum PullMsgReason {
    INIT = 0,
    MORE_PAGE = 1,
    CURSOR = 2,
    NET = 3,
    MANUAL = 4,
    DONE = 5,
    TOKEN_REFRESH = 6,
    END_ERROR = 7,
    POLLING = 8,
    MIGRATE = 9,
    ENTERCHAT = 10,
    SPLIT_DB_ROLLBACK = 11,
    NEED_PULL = 12
}
export declare enum ConversationChangeReason {
    INIT = 0,
    GET_USER_MSG_UPDATE = 1,
    UNKNOWN = 2,
    MEMBER_CHANGE = 3,
    BOT_CHANGE = 4,
    MSG_UPDATE = 5,
    MARK_READ = 6,
    LEAVE_CONVERSATION = 7,
    CREATE_TEMP = 8,
    DRAFT_CHANGE = 9,
    HAS_MORE_CHANGE = 10,
    LOCAL_EXT_CHANGE = 11,
    LOCAL_KV_CHANGE = 12,
    CORE_INFO_CHANGE = 13,
    SETTING_INFO_CHANGE = 14,
    LABEL_CHANGE = 15,
    STICK_TOP = 16,
    REFRESH_ALL = 17,
    EDIT_CONTENT = 18
}
/** Ext 字段 Key */
export declare enum IMInfoKeys {
    /** 发送消息 Response 中的 字段 */
    SDK_SEND_RESPONSE_EXTRA_CODE = "s:send_response_extra_code",
    /** 发送消息 Response 中的 字段 */
    SDK_SEND_RESPONSE_EXTRA_MSG = "s:send_response_extra_msg",
    /** 发送消息 Response 中的 checkCode 字段 */
    SDK_SEND_RESPONSE_CHECK_CODE = "s:send_response_check_code",
    /** 发送消息 Response 中的 checkMessage 字段 */
    SDK_SEND_RESPONSE_CHECK_MSG = "s:send_response_check_msg",
    /**
     * 消息客户端 Id
     * {@link Message.clientId}
     */
    SDK_MSG_UUID = "s:client_message_id",
    /** 被撤回的目标消息msgUuid */
    SDK_TARGET_RECALL_MSG_UUID = "s:target_client_message_id",
    /** 被撤回的目标消息的msgId */
    SDK_TARGET_RECALL_MSG_ID = "s:target_server_message_id",
    /**
     * 被 @ 的用户
     * {@link Message.mentionedUsers}
     */
    SDK_MENTION_USER = "s:mentioned_users",
    /** 表示所要at的集合 */
    SDK_MENTIONED_COLLECTIONS = "s:mentioned_collections",
    /** 表示被集合at(比如在@所有人里，就是1)，由服务端控制（s：前缀）,存放特定的枚举值 */
    SDK_MENTIONED_IN_COLLECTIONS = "s:mentioned_in_collections",
    /**
     * 设置这个标记为 `'true'` 时, 客户端不会把这条消息算入未读数内
     * 可以用于退群系统消息等
     */
    SDK_NOT_UP_UNREAD = "s:do_not_increase_unread",
    /**
     * 设置这个标记为 `'true'` 时, 客户端不会因为这条消息而把会话往上顶
     * 可以用于退群系统消息等
     */
    SDK_NOT_POP_CONVERSATION = "s:do_not_pop_conversation",
    /**
     * "1",是批量发送消息（一键给好多群发）
     */
    SDK_MSG_BATCH_SEND = "s:is_im_batch",
    /** 消息可见用户 */
    SDK_MSG_SELF_VISIBLE = "s:visible",
    /** 消息不可见用户 */
    SDK_MSG_SELF_INVISIBLE = "s:invisible",
    /** 消息被撤回 */
    SDK_MSG_RECALLED = "s:is_recalled",
    /** 消息撤回的角色 */
    SDK_RECALLED_ROLE = "s:recall_role",
    /** 更新消息使用 */
    SDK_MSG_ORIGINAL_INDEX = "s:original_index",
    /** 消息的 Server Id */
    SDK_MSG_ORIGINAL_SVR_ID = "s:server_message_id",
    /***发送消息的错误码**/
    SDK_MSG_SEND_ERROR_CODE = "s:err_code",
    /***发送消息的错误提示信息**/
    SDK_MSG_SEND_ERROR_MSG = "s:err_msg",
    /***当消息是通过拉取的方式得到时，打上这个标记**/
    SDK_MSG_GET_BY_PULL = "s:msg_get_by_pull",
    /***ActionType 列表，逗号分隔，标记已收藏/PIN**/
    SDK_MSG_MARKED = "s:action_type",
    SDK_MSG_MARKE_SORT_TIME = "s:mark_sort_time",
    SDK_MSG_MARKE_TOP_MSG = "conv_top_msg",
    /***会话名称（群名）**/
    SDK_CONVERSATION_NAME = "s:name",
    /**
     * @deprecated use core info
     * 会话描述
     */
    SDK_CONVERSATION_DESC = "s:desc",
    /**
     * @deprecated use core info
     */
    SDK_CONVERSATION_ICON = "s:icon",
    /**
     * @deprecated use core info
     */
    SDK_CONVERSATION_NOTICE = "s:notice",
    /**
     * @deprecated use setting info
     */
    SDK_CONVERSATION_STICK_TOP = "s:stick_on_top",
    /**
     * @deprecated use setting info
     */
    SDK_CONVERSATION_MUTE = "s:mute",
    /**
     * @deprecated use setting info
     */
    SDK_CONVERSATION_FAVORITE = "s:favorite",
    /** 当获取会话信息失败，且本地创建了一个空会话时，带上这个字段用于标记，下次pull完成后时自动重试 */
    SDK_CONVERSATION_WAIT_INFO = "s:conv_wait_info",
    /** 用于标记Message.index是否为local的key，"1"：local，"0"：server */
    SDK_MESSAGE_INDEX_IS_LOCAL = "s:message_index_is_local",
    /**
     * 用于标记Message是否要插入到顶部，仅改MessageModel中顺序
     */
    SDK_MESSAGE_INDEX_IS_FIRST = "s:message_index_is_first",
    IS_STRANGER_MESSAGE = "s:is_stranger_message",
    IS_STRANGER_GARBAGE_CONV = "is_garbage_conv",
    LOG_ID = "s:log_id",
    /**
     * 消息体中携带的发送者信息
     */
    SDK_MESSAGE_SENDER_PROTRAIT = "s:protrait",
    SDK_MESSAGE_SENDER_NAME = "s:nick_name",
    SDK_MESSAGE_SENDER_OTHER = "s:basic_ext_info",
    /**
     * 风控信息
     */
    SDK_SHARK_NOTICE_TYPE = "s:shark_notice_type",
    SDK_SHARK_NOTICE = "s:shark_notice",
    /**
     * 是否有更新过read_badge_count
     */
    SDK_READ_BADGE_COUNT_UPDATE = "s:read_badge_count_update",
    /**
     * 引用消息的id 存储在 localExt
     */
    SDK_REF_MSG_ID = "s:sdk_ref_msg_id",
    SDK_KEY_REF_MSG_PREFIX = "ref_",
    /**
     * 消息发送失败异步命令消息50014携带的client_msg_id
     */
    SDK_SEND_FAIL_CLIENT_MSG_ID = "s:fail_ref_client_msg_id",
    /**
     * 下推普通消息ext中携带的check_message
     */
    SDK_SEND_MSG_RESP = "s:send_msg_resp",
    /**
     * 消息盒子
     */
    SDK_IS_IN_BOX = "a:s_is_in_box",
    /**
     * 折叠盒子
     */
    SDK_IS_FOLDED = "a:s_is_folded",
    /**
     * 创作者私信优化, 陌生人盒子, '1': 属于陌生人消息盒子会话，'0': 正常会话
     */
    SDK_IS_IN_STRANGER_BOX = "a:is_in_stranger_box",
    /**
     * 消息盒子咨询弹窗显示时间戳
     */
    SDK_SHOW_MSG_BOX_NOTICE = "a:show_msg_box_notice",
    /**
     * 咨询弹窗显示时间戳
     */
    SDK_PUSH_ALLOWED = "a:push_allowed",
    /**
     * 创作者私信体验优化实验值上传
     */
    SDK_IM_CREATOR_CHAT_OPT_EXP = "s:im_creator_chat_opt_exp",
    /**
     * 私信隐私权限优化实验值上传
     */
    SDK_IM_PRIVACY_SETTING_OPT_EXP = "s:im_chat_priv_opt_exp",
    /**
     * 发消息ticket及创建会话优化
     */
    SDK_SEND_IGNORE_TICKET = "s:send_ignore_ticket",
    SDK_WAIT_FOR_SEND = "s:wait_for_send",
    /**
     * 交换答案， 标记该消息 已回答
     */
    SDK_EXCHANGE_ANSWER_ACKED = "s:answer_acked",
    /**
     * 交换答案， 标记相关问题被回答，可以展示成'查看答案'
     */
    SDK_EXCHANGE_ANSWER_SHOW = "s:answer_show",
    /**
     * 会话网页链接卡片化
     */
    SDK_WEB_LINK_CARDS = "a:url_card_brief",
    /**
     * 创作者私信反转实验
     */
    SDK_REVERSE_CREATOR_REVERSE_MESSAGE = "s:reverse_creator_im_ex",
    /**
     * 春节项目交换红包
     */
    SDK_EXCHANGE_UPDATE = "a:exchange_update",
    SDK_EXCHANGE_STATUS = "a:exchange_status",
    SDK_EXCHANGE_INFO = "a:exchange_info",
    SDK_EXCHANGE_EXT_END = "a:exchange_rp",
    /**
     * 天眼项目透传字段，会跟随 ConversationInfo里的ConversationSettingInfo#ext里传下来
     */
    SDK_SKY_EYE = "a:sky_eye_dialog",
    SDK_SKY_EYE_LIST = "a:sky_eye_dialog_list",
    SDK_SKY_EYE_CHAT_BAR = "a:sky_eye_chat_bar",
    /**
     * 违规媒体消息，业务方需展示裂图
     */
    SDK_RIP_MEDIA = "a:s_rip_media",
    /**
     * 违规消息处罚状态
     * '1': 被处罚
     * '2': 被处罚后恢复
     * 其他: 未被处罚
     */
    SDK_HIDE_STATUS = "a:s_async_hide_status",
    /**
     * 被处罚后 消息气泡需展示的文案
     */
    SDK_HIDE_TIPS = "a:s_async_hide_msg",
    SDK_KEY_HISTORY_UNREAD_GROUP_OWNER_MSG_STATUS = "a:s_history_unread_group_owner_msg_status",
    /**
     * 撤回消息时间戳记录
     */
    SDK_TEXT_RECALL_TIMESTAMP = "s:text_recall_timestamp",
    /**
     * 支持跳过免打扰的未读消息数(设置接收部分消息的未读数)
     */
    SDK_UNREAD_SKIP_MUTE_MSG_COUNT = "unread_skip_mute_msg_count",
    SDK_UNREAD_IMPORTANG_MSG_COUNT = "unread_important_msg_count",
    /**
     * 接受部分跳过免打扰 消息配置
     *
     * 'mentioned_by_user': '1',   有人at我
     * 'send_by_group_owner': '1',  群主客户端自己发（群主发言）
     * 'auto_send_by_server': '1',  群主服务端自动发（开播提醒/作品同步）
     * 'mention_and_send_by_group_owner' 群主艾特
     */
    SDK_PUSH_PART_DISABLE_CONFIG = "a:push_part_disable_config",
    SDK_MENTIONED_BY_USER = "mentioned_by_user",
    SDK_SEND_BY_GROUP_OWNER = "send_by_group_owner",
    SDK_AUTO_SEND_BY_SERVER = "auto_send_by_server",
    SDK_MENTIONED_AND_SEND_BY_GROUP_OWNER = "mention_and_send_by_group_owner",
    SDK_MSG_READ_BADGE_COUNT = "_read_badge_count",
    SDK_MSG_BADGE_COUNT = "_badge_count",
    SDK_MSG_REMINDER_CONFIG = "msg_reminder_config_",
    /**
     * 1：群主发言 2：优惠券 3：直播公告 4：群投票
     */
    SDK_HINT_TYPE = "a:hint_type",
    /**
     *  2：开播提醒 1：视频作品同步 3：图文作品同步
     */
    SDK_GROUP_OWNER_AUTO_SEND_TYPE = "a:group_owner_auto_send_type",
    /**
     * 群聊机器人
     */
    SDK_GROUP_BOTS_INFO = "a:group_bots_info",
    SHOOT_TOGETHER_MSG_IDS = "im_my_mix_photo_messageIDs",
    /**
     *  日常作品
     */
    SDK_GROUP_IS_STORY_WORK = "a:is_story_work",
    /**
     * 安全处罚下发的信息
     */
    SDK_SAFE_INFO = "a:s_risk_warning",
    /**
     * 直播留咨达人uid字段
     */
    SDK_SERVICE_PROVIDER_UID = "a:s_service_provider_uid",
    /**
     * 直播留咨达人uid字段
     */
    SDK_SERVICE_PROVIDER_SEC_UID = "a:s_service_provider_sec_uid",
    /**
     * 直播留咨达人消息发送时角色字段
     */
    CONSULT_MSG_SENDER_ROLE = "a:s_sender_role",
    /**
     * 直播留咨达人消息发送时角色字段
     */
    CONSULT_MSG_SENDER_NAME = "a:s_sender_nickname",
    /**
     * 直播留咨达人动态消息卡片宽高
     */
    CONSULT_MSG_DYNAMIC_HEIGHT = "a:dynamic_card_height",
    CONSULT_MSG_DYNAMIC_WIDTH = "a:dynamic_card_width",
    MSG_DISABLE_OPTION = "a:disable_op",
    KEY_CARD_DISPLAY_MASK = "a:show_mask",
    SDK_LAST_UPDATE_CONV_INFO_TIME = "a:s_last_update_conv_info_time",
    KEY_CONVERSATION_LABEL_WATCH = "a:s_awe_not_often_seen_v2",
    SDK_PUSH_ALLOWED_NOT_OFTEN_SEE = "a:push_allowed_not_often_seen_v2",
    KEY_CONVERSATION_LEGAL_UID = "conversation_legal_uid",
    KEY_CONVERSATION_LEGAL_FROM = "conversation_legal_from",
    KEY_GROUP_CONVERSATION_CHECK = "group_conversation_check",
    KEY_MESSAGE_SOURCE_TEST = "message_source_test",
    KEY_SHARE_MERGE_ORIGIN_CON_ID = "a:share_merge_origin_con_id",
    KEY_IS_SHARE_MERGE = "a:is_share_merge",
    KEY_REWARD_TOAST_SHOWN = "a:reward_toast_shown",
    KET_NOT_FLOAT = "a:msg_not_float",
    KEY_SENDER = "sender",
    KEY_RECEIVER = "receiver",
    KEY_BOTH = "both",
    KEY_MARK_NOT_DISPLAY_TIME = "s:mark_invisible_time",
    KEY_STICKER_ID = "a:sticker_id",
    KEY_CREATE_GROUP_TYPE = "a:s_group_create_type",
    KEY_LOCAL_SETTING_KEY = "a:s_group_setting",
    KEY_VIDEO_EMOJI_REC = "a:video_emoji_rec",
    /**
     * 消息二次编辑
     */
    SDK_EDIT_CONTENT_INFO = "s:edit_info",
    /**
     * 消息已经编辑的次数
     */
    SDK_EDIT_CONTENT_EDIT_COUNT = "s:edit_count",
    KEY_TOOL_ID = "a:cs:tool_id",
    MAGIC_EFFECT_KEY = "a:magic_effect_key",
    MAGIC_EFFECT_EXPIRE_AT = "a:magic_effect_expire_at",
    SPRING_FES_24_TASK_ID = "a:spring_fes_24_task_id",
    SPRING_FES_24_TASK_TYPE = "a:spring_fes_24_task_type",
    SPRING_FES_24_TASK_LABEL = "a:spring_fes_24_task_label",
    SPRING_FES_24_TASK_MD5 = "a:spring_fes_24_task_md5",
    SPRING_FES_24_RAIN_ID = "a:spring_fes_24_rain_id",
    SPRING_FES_24_JIKA_EMOJI = "a:hlg_jika_emoji",
    SPRING_FES_24_THEME_PIC_REC_RES = "a:spring_fes_24_theme_pic_rec_res",
    SPRING_FES_24_THEME_PIC_FAIL_INFO = "a:spring_fes_24_theme_pic_failed_info",
    /**
     * 以下类型来自IMCloud
     */
    MessageMode = "s:mode",
    /** 发送消息 Response 中的 statusCode 字段 */
    SendResponseStatus = "s:send_response_status",
    /** 发送消息 Response 中的 extraInfo 字段 */
    SendResponseExtraInfo = "s:send_response_extra_info",
    /** logid, 上报 RTT 用 */
    LocalLogId = "s:local_logid",
    /** 会话是否开启禁言 **/
    RelationIsMuted = "s:relation_is_muted",
    /** 会话是否被服务端禁言 **/
    RelationIsMutedServer = "s:relation_is_muted_server",
    /** 是否只禁言普通成员 **/
    RelationNormalOnly = "s:relation_normal_only",
    RelationMuteTime = "s:relation_mute_time",
    RelationMuteExt = "s:relation_mute_ext",
    MessageSourceAppId = "s:biz_aid",
    ConversationSourceAppId = "s:s_aid",
    IsRootReference = "s:is_root_ref",
    MarkMessageNewExt = "s:mark_message_new_ext",
    AckSampling = "s:is_ack_sampling",
    AckSamplingShow = "s:is_ack_sampling_show",
    DoNotUpdateLastMessage = "s:do_not_update_last_msg",
    DoNotMoveReadIndex = "s:do_not_move_read_index",
    /** 音频消息转换后的文字 */
    FileExtKeyAudioAsrText = "s:file_ext_key_audio_asr_text",
    /** 保存check_code 透传给用户 约定命中敏感词 用户在tcc上配置*/
    RecognitionResponseCheckCode = "s:recognition_response_check_code",
    /** 保存check_message 透传给用户 */
    RecognitionResponseCheckMsg = "s:recognition_response_check_msg",
    /**
     * 低打扰模式时，设置关注的用户/消息类型
     */
    PushPartDisableConfig = "s:push_part_disable_config",
    /**
     * 消息强制通知
     */
    MustNotify = "s:must_notify",
    SendTime = "s:stime",
    /**
     * 会话绑定的业务维度标签
     */
    ConversationTags = "s:conversation_tag",
    /**
     * 会话绑定的用户维度标签
     */
    UserCustomConversationTags = "s:user_custom_conversation_tag",
    /**
     * 被引用的消息内容，ReferenceInfo.ext 使用
     */
    RefContent = "s:ref_content",
    /**
     * 被引用的消息是否已编辑，为 `'true'` 时代表已被编辑，ReferenceInfo.ext 使用
     */
    RefIsEdited = "s:ref_is_edited",
    /**
     * 字符串类型的uid,同 SDK_S_USERID_STR
     */
    SDK_S_UID_STR = "s:Uid",
    SDK_S_USERID_STR = "s:UserId",
    SDK_S_SENDER_STR = "s:Sender",
    SDK_S_USERID_STR_List = "s:UserIds",
    /**
     * 消息调用发送接口时间(NTP)
     */
    SDK_S_SEND_TIME = "s:stime",
    /**
     * 消息发送平台
     */
    SDK_A_SEND_OS = "a:send_os"
}
export declare class TableFlagEnum {
    static _FLAG_ATTACHMENT: bigint;
    static _FLAG_MSG_PROPERTY: bigint;
}
export declare const PushPartDisableConfigWhiteListKey = "mute_wl";
/** 消息服务端状态 */
export declare enum ServerMessageStatus {
    /** 启用 (正常状态) */
    Enable = 0,
    /** 禁用 (不显示) */
    Disable = 1
}
/** 会话类型 */
export declare enum ConversationType {
    /** 单聊会话 */
    SingleChat = 1,
    /** 群聊会话 */
    GroupChat = 2,
    /** 轻直播会话 */
    LiveChat = 3,
    CONSULT_CHAT = 18
}
/** 会话状态 */
export declare enum ConversationStatus {
    /** 正常状态 */
    Normal = 0,
    /** 已被解散 */
    Dissolved = 1
}
/** 置顶状态 */
export declare enum StickTopState {
    /** 未置顶 */
    Off = 0,
    /** 已置顶 */
    On = 1
}
/** 免打扰状态 */
export declare enum MuteState {
    /** 普通提醒 */
    Off = 0,
    /** 免打扰 (不提醒) */
    On = 1
}
/** 消息推送模式 */
export declare enum PushStatus {
    /**
     * 服务端未返回，或不支持的类型
     */
    Unknown = 0,
    /**
     * 正常模式（允许推送）
     */
    Allow = 1,
    /**
     * 免打扰模式（禁止推送）
     */
    Disable = 2,
    /**
     * 低打扰模式（部分推送）
     */
    PartAllow = 3
}
/** 收藏状态 */
export declare enum FavoriteState {
    /** 未收藏 */
    Off = 0,
    /** 已收藏 */
    On = 1
}
/** SDK 初始化状态 */
export declare enum InitResult {
    /** 不可用 / 未知 */
    NotAvailable = 0,
    /** 正在初始化 */
    Start = 1,
    /** 初始化出错 */
    Error = 2,
    /** 初始化成功完成 */
    Succeeded = 3
}
/**
 * 消息来源
 * {@link InfoKeys.MessageSource}
 */
export declare enum MsgSource {
    UNKNOWN = -1,
    /**
     * 长链在线接收的消息
     */
    ONLINE = 0,
    /**
     * 拉取单个会话的历史消息
     */
    LOAD_MORE = 1,
    /**
     * 初始化
     */
    INIT = 2,
    /**
     * 用户混链
     */
    MIX_LINK = 3,
    /**
     * 最近会话
     */
    RECENT_LINK = 4,
    /**
     * 命令消息混链
     */
    CMD_LINK = 5,
    /**
     * 会话内消息补偿单链
     */
    INDEX_V2_LINK = 6,
    /**
     * 陌生人最近会话链
     */
    RECENT_STRANGER_LINK = 7,
    /**
     * 拉取会话特定类型消息
     */
    SPECIFIED_MSG = 8
}
/** IM 错误类型 */
export declare enum ErrorType {
    /** 未知错误 */
    Unknown = -1,
    /** 成功 */
    Success = 0,
    /** 无效tokne */
    InvalidToken = 1,
    /** 无效ticket */
    InvalidTicket = 2,
    /** 取消请求 */
    InvalidRequest = 4,
    /** 无效命令 */
    InvalidCommand = 5,
    /** 服务端错误 */
    ServerError = 6,
    UserForbidden = 11,
    MessageTargetConversationNotExist = 15,
    /** 服务降级 */
    Degradation = 16,
    /** 撤回超时 */
    RecallTimeout = 17,
    CallbackDeny = 19,
    /** token过期 */
    ExpiredToken = 100,
    /** 传入参数不合法 */
    InvalidParam = 400,
    /** 资源耗尽 */
    ResourceExhausted = 429,
    /** 内部错误 */
    InternalError = 500,
    /** 不合法的 InboxType, 由于某个必须指定 InboxType 的接口未传入 InboxType 导致 */
    InvalidInboxType = 1000,
    /**
     * 会话不存在
     * {@link ConversationNotExistError}
     */
    ConversationNotExist = 1001,
    /** 消息不存在 */
    MessageNotExist = 1002,
    /** 消息尚未发送（消息离线保存） */
    MessageOffline = 1003,
    /** 无法识别的消息类型, 收到了 type 为负数的消息 */
    UnknownMessageType = 1004,
    /** 不合法的 Message Server Id, 收到 50002 消息时没有 s:server_message_id 字段 */
    InvalidServerId = 1005,
    /** 消息尚未准备好, 在消息还未到达服务端时就尝试对其进行操作 */
    MessageNotReady = 1006,
    /** Token 函数失败, 自动刷新 Token 机制未能获取到可用的新 Token */
    TokenFuncError = 1007,
    /** 网络错误 */
    NetworkError = 1008,
    /** 已销毁 */
    AlreadyDispose = 1009,
    /** 适配器不存在 */
    NoAdapter = 1010,
    ComponentNotFound = 1011,
    /** 未实现某功能 */
    NotImplemented = 1012,
    /**
     * 需要 {@link MultimediaPlugin}
     *
     * 参数不合法
     */
    MPInvalidArgument = 10001,
    /**
     * 需要 {@link MultimediaPlugin}
     *
     * 无法解析返回的 url
     */
    MPServerUrlError = 10002,
    /**
     * 需要 {@link MultimediaPlugin}
     *
     * 不是一个文件消息
     */
    MPNotFileMsg = 10003,
    /**
     * 需要 {@link MultimediaPlugin}
     *
     * 上传出错
     */
    MPUploadError = 10004,
    /** 解密失败 */
    MPNotSupportCipher = 10005,
    DbOpError = 20000,
    StorageCryptoError = 20001,
    AuthSignError = 10201
}
/** 消息发送状态 */
export declare enum FlightStatus {
    /** 消息已经创建 */
    Created = 0,
    /** 准备中 (图片正在上传等) */
    Preparing = 1,
    /** 发送中 (已经提交请求, 尚未收到响应) */
    Sending = 2,
    /** 发送成功 (已经收到响应) */
    Succeeded = 3,
    Received = 4,
    /** 发送失败 (网络错误, 内部错误等) */
    Failed = -1,
    /** 消息被服务端拒绝 (回调检查) */
    Rejected = -2,
    /** 消息被自见 */
    SelfVisible = -3
}
/** 消息发送状态 */
export declare enum SendMsgStatus {
    /**
     * 发送等待, 消息只添加数据库
     */
    PENDING = 0,
    /**
     * 发送中
     */
    SENDING = 1,
    /**
     * 发送成功
     */
    SUCCESS = 2,
    /**
     * 发送失败
     */
    FAIL = 3,
    /**
     * 正在上传消息的文件部分
     */
    SENDING_FILE_PARTS = 4,
    /**
     * 收到的消息或是拉取到的发送消息
     */
    NORMAL = 5
}
export declare enum BatchUpsertSettingExtSource {
    MSG_BOX = 0,
    LABEL = 1
}
export declare enum SendMessageStatusCode {
    Succeeded = 0,
    UserNotInConversation = 1,
    CheckConversationNotPass = 2,
    CheckMessageNotPass = 3,
    CheckMessageNotPassButSelfVisible = 4,
    UserHasBeenBlock = 5
}
export declare enum PartMsgReminderStateEnum {
    ON = "1",
    OFF = "0"
}
export declare enum CreateConversationStatusCode {
    Succeeded = 0,
    Rejected = 1,
    PartialRejected = 2
}
export declare enum InBoxType {
    DEFAULT = 0,
    D_INIT = 1,
    DOUYIN_LIVE_CONSULT = 2,
    INBOX_TYPE_YI_QI_KAN = 3
}
export declare enum IMConfigKey {
    sharkEnabled = "sharkEnabled",
    autoFetchMsgEnabled = "autoFetchMsgEnabled",
    autoFetchMsgInterval = "autoFetchMsgInterval",
    conversationMsgRepairInterval = "conversationMsgRepairInterval",
    conversationMsgRepairStart = "conversationMsgRepairStart",
    conversationMsgRepairCount = "conversationMsgRepairCount",
    conversationMsgRepairRatio = "conversationMsgRepairRatio",
    UnreadCountReport = "UnreadCountReport",
    autoPollingMsgEnabled = "autoPollingMsgEnabled",
    triggerPollingMsgEnabled = "triggerPollingMsgEnabled",
    defaultPollingMsgInterval = "defaultPollingMsgInterval",
    unmuteWhiteUidsLen = "unmuteWhiteUidsLen"
}
export declare enum PayloadEncodeType {
    PB = "pb",
    LZ4 = "__lz4"
}
export declare enum DeletedFlag {
    NOT_DELETE = 0,
    DELETED = 1
}
/**
 * IM所有操作的结果状态码
 */
export declare enum StatusCode {
    /**
     * 操作成功
     */
    OK = 0,
    HTTP_OK = 200,
    /**
     * 用户token无效
     */
    INVALID_TOKEN = 1,
    /**
     * 用户token过期
     */
    EXPIRED_TOKEN = 100,
    /**
     * 会话ticket失效
     */
    INVALID_TICKET = 2,
    /**
     * 无效请求
     */
    INVALID_REQUEST = 4,
    /**
     * 无效请求指令
     */
    INVALID_CMD = 5,
    /**
     * 服务器异常
     */
    SERVER_ERR = 6,
    /**
     * 发送消息时会话不存在
     */
    MESSAGE_TARGET_CONVERSATION_NOT_EXIST = 15,
    IM_HTTP_FAIL = -1000,
    /**
     * IM 未上线
     */
    IM_NOT_ONLINE = -1001,
    /**
     * 发送请求超时
     */
    IM_SEND_TIME_OUT = -1002,
    /**
     * 发送请求失败
     */
    IM_SEND_RETRY_FAIL = -1003,
    /**
     * 长连接未连接
     */
    IM_WS_NOT_CONNECT = -1006,
    /**
     * 客户端发送消息失败
     */
    IM_SEND_MESSAGE_FAIL = -1009,
    /**
     * 客户端接收消息失败
     */
    IM_GET_MESSAGE_FAIL = -1010,
    /**
     * 客户端拉取 uid 错误
     */
    IM_GET_UID_FAIL = -1011,
    /**
     * 用户token为空
     */
    IM_TOKEN_IS_NULL_IN_QUE = -1013,
    /**
     * 网络不可用
     */
    IM_NETWORI_NOT_AVAILABLE = -1014,
    /**
     * 参数非法
     */
    IM_ILLEGAL_PARAMETERS = -1015,
    /**
     * 会话已存在
     */
    IM_CREATE_CONVERSATION_ALREADY_EXIST = -1016,
    /**
     * 本地会话不存在
     */
    IM_LOCAL_CONVERSATION_NOT_EXIST = -1017,
    /**
     * 会话信息正在获取中
     */
    IM_GET_CONVERSATION_INFO_ALREADY_EXIST = -1018,
    /**
     * http host 无效
     */
    IM_INVALID_HTTP_HOST = -1019,
    /**
     * 编码失败
     */
    ENCODE_REQ_MSG_FAIL = -2001,
    /**
     * 编码数据不合法
     */
    ENCODE_REQ_DATA_VALID = -2002,
    /**
     * 解码失败
     */
    DECODE_WS_MSG_FAIL = -2003,
    /**
     * 编码太长，超过长链接2048限制
     */
    ENCODE_REQ_MSG_TOO_LARGE = -2004,
    /**
     * 数据库写失败
     */
    DB_INSERT_FAIL = -3001,
    /**
     * 未知错误
     */
    UNKNOWN_ERROR = -9999
}
export declare let GroupRole: typeof im_proto.GroupRole;
export declare enum ExtraMessageType {
    /**
     * 火龙果任务更新推送
     */
    MESSAGE_TYPE_HUOLONGGUO = 50023,
    /**
     * 火龙果杂项消息推送
     */
    MESSAGE_TYPE_HUOLONGGUO_MISC = 50024
}
export declare class RecentLinkConfig {
    static BASE_INDEX_V2: bigint;
}
export declare enum ReadStatus {
    UNREAD = 0,
    READ = 1
}
export declare class IMConstants {
    static KEY_REPAIRED_RANGE_LIST: string;
    static KEY_CHECK_RANGE: string;
    static KEY_ORDER_TIMESTAMP: string;
    static KEY_LAST_CHECK_MSG_LEAK_UUID: string;
    static KEY_WITH_USER_PROMPT_INFO: string;
    static KEY_TOP_MSG_MODELS: string;
}
export declare enum StrangerStatus {
    UNKNOWN = -1,
    NO = 0,
    YES = 1
}
export declare enum FoldStatusEnum {
    UNKNOWN = -1,
    NO = 0,
    YES = 1
}
export declare enum CommonStatusEnum {
    UNKNOWN = -1,
    NO = 0,
    YES = 1
}
export declare enum ConversationMarkDelParamEnum {
    /**
     * 需要全部会话, 包括标记删除和非标记删除
     */
    NEED_ALL_CONV = 0,
    /**
     * 仅返回未被删除的会话
     */
    NEED_NORMAL_CONV = 1,
    /**
     * 仅返回被删除的会话
     */
    NEED_MARK_DEL_CONV = 2
}
export declare class PullStrangerSource {
    static COLD_UP: string;
    static MANUAL: string;
    static NET: string;
    static VERSION: string;
    static LOAD_MORE: string;
    static UNKNOWN: string;
}
export declare class CommandMessageType {
    static MARK_CONVERSATION_READ: number;
    static DELETE_MESSAGE: number;
    static DELETE_CONVERSATION: number;
    static UPDATE_CONVERSATION: number;
    static UPDATE_GROUP: number;
    static UPDATE_GROUP_MEMBER: number;
    static MARK_CONVERSATION_NO_MORE: number;
    static MARK_CONVERSATION_LOAD_MORE: number;
    static MARK_CONVERSATION_OPTIMIZE: number;
    static CONVERSATION_ROBOT_UPDATE_TYPE: number;
}

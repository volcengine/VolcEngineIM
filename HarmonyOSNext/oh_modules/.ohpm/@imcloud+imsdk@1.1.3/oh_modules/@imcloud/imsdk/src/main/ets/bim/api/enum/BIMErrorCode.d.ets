/**
 * @detail errorcode
 * @brief 错误码
 */
export declare enum BIMErrorCode {
    /**
     * @brief 成功
     */
    BIM_OK = 0,
    /**
     * @brief Token 非法
     */
    BIM_SERVER_INVALID_TOKEN = 1,
    /**
     * @brief Token 过期
     */
    BIM_SERVER_EXPIRED_TOKEN = 100,
    /**
     * @brief 非法票据
     */
    BIM_SERVER_INVALID_TICKET = 2,
    /**
     * @brief 会话不存在
     */
    BIM_SERVER_CONVERSATION_NOT_FOUND = 3,
    /**
     * @brief 请求非法
     */
    BIM_SERVER_INVALID_REQUEST = 4,
    /**
     * @brief 接口非法
     */
    BIM_SERVER_INVALID_CMD = 5,
    /**
     * @brief 服务端错误
     */
    BIM_SERVER_SERVER_ERR = 6,
    /**
     * @brief 用户群权限校验不合法（权限不够专用）
     */
    BIM_SERVER_USER_FORBIDDEN = 11,
    /**
     * @brief 设备未绑定
     */
    BIM_SERVER_DEVICE_NOT_BIND = 7,
    /**
     * @brief 命中非法敏感词
     */
    BIM_SERVER_MESSAGE_ILLEGAL = 8,
    /**
     * @brief 非法用户，如用户被 ban
     */
    BIM_SERVER_USER_ILLEGAL = 9,
    /**
     * @brief 非法用户，如用户被 ban
     */
    BIM_SERVER_USER_NOT_FRIENDS = 10,
    /**
     * @brief 按级别沉默用户
     */
    BIM_SERVER_USER_SILENCE = 12,
    /**
     * @brief 用户不在当前组中（未加入、已被移除等）
     */
    BIM_SERVER_USER_NOT_IN_GROUP = 13,
    /**
     * @brief 用户当前组内被禁言
     */
    BIM_SERVER_USER_BANNED_TO_POS = 14,
    /**
     * @brief 服务内部错误，一般是调用下游 RPC 错误
     */
    BIM_SERVER_INTERNAL_ERROR = 500,
    /**
     * @brief 发送消息时会话不存在
     */
    BIM_SERVER_MESSAGE_TARGET_CONVERSATION_NOT_EXIST = 15,
    /**
     * @brief 请求被降级
     */
    BIM_SERVER_DEGRADATION_ERROR = 16,
    /**
     * @brief 撤回超时
     */
    BIM_SERVER_RECALL_TIMEOUT = 17,
    /**
     * @brief 到达上限
     */
    BIM_SERVER_TOUCH_LIMIT = 18,
    /**
     * @brief 服务禁止回调
     */
    BIM_SERVER_CALLBACK_DENY = 19,
    /**
     * @brief 消息体过大
     */
    BIM_SERVER_ERROR_SEND_MESSAGE_TOO_LARGE = 21,
    /**
     * @brief 会话不存在
     */
    BIM_SERVER_CONVERSATION_NOT_EXIST = 50,
    /**
     * @brief app 已经被停用或者删除
     */
    BIM_SERVER_APP_NOT_NORMAL = 51,
    /**
     * @brief 直播群管理员超过限制
     */
    BIM_SERVER_MASS_MANAGER_MORE_THAN_LIMIT = 52,
    /**
     * @brief 用户被拉黑, 无法执行此操作
     */
    BIM_SERVER_MEMBER_BLOCK = 53,
    /**
     * @brief 会话并没有全局禁言
     */
    BIM_SERVER_CONVERSATION_IS_NOT_MUTE = 54,
    /**
     * @brief 用户 ID 与 token 校验不匹配，鉴权失败
     */
    BIM_SERVER_USERID_MISMATCH_TOKEN = 55,
    /**
     * @brief 不是好友
     */
    BIM_SERVER_NOT_FRIEND = 56,
    /**
     * @brief 重复发起好友申请
     */
    BIM_SERVER_DUPLICATE_APPLY = 57,
    /**
     * @brief 不是申请中，无法修改好友状态
     */
    BIM_SERVER_NOT_APPLYING = 58,
    /**
     * @brief 更新有并发问题
     */
    BIM_SERVER_UPDATE_FREQUENT = 59,
    /**
     * @brief 已经是好友了
     */
    BIM_SERVER_IS_FRIEND = 60,
    /**
     * @brief 好友个数超过上限,本端
     */
    BIM_SERVER_FRIEND_MORE_THAN_LIMIT = 61,
    /**
     * @brief 禁止添加自己为好友
     */
    BIM_SERVER_ADD_SELF_FRIEND_NOT_ALLOW = 62,
    /**
     * @brief 好友个数超过上限, 对端
     */
    BIM_SERVER_FROM_USER_FRIEND_MORE_THAN_LIMIT = 63,
    /**
     * @brief 用户已在黑名单
     */
    BIM_SERVER_AlREADY_IN_BLACK = 64,
    /**
     * @brief 用户已被移出黑名单
     */
    BIM_SERVER_ALREADY_BEEN_REMOVED = 65,
    /**
     * @brief 黑名单用户超出限制
     */
    BIM_SERVER_BLACK_MORE_THAN_LIMIT = 66,
    /**
     * @brief 不允许将自己添加到黑名单
     */
    BIM_SERVER_ADD_SELF_BLACK_NOT_ALLOW = 67,
    /**
     * @brief 好友备注过长
     */
    BIM_SERVER_ALIAS_TOO_LONG = 68,
    /**
     * @brief 好友备注被风控拦截
     */
    BIM_SERVER_ALIAS_ILLEGAL = 69,
    /**
     * @brief 试用版 DAU 超过个数限制，参看[计费规则](https://www.volcengine.com/docs/6348/273864)。
     */
    BIM_SERVER_TRIAL_VERSION_DAU_COUNT_MORE_THAN_LIMIT = 72,
    /**
     * @brief 会话的标记超过上限。
     */
    BIM_SERVER_CONVERSATION_MARK_TYPE_MORE_THAN_LIMIT = 73,
    /**
     * @brief 消息过期。
     */
    BIM_SERVER_MESSAGE_EXPIRE = 74,
    /**
     * @brief 未开通群聊已读回执功能。如需开通，请联系技术支持。
     */
    BIM_SERVER_MESSAGE_RECEIPT_DISABLE = 75,
    /**
     * @brief 群人数超过已读回执支持人数。
     */
    BIM_SERVER_READ_RECEIPT_GROUP_MEMBER_MORE_THAN_LIMIT = 76,
    /**
     * @brief 未知错误
     */
    UNKNOWN = 10000,
    /**
     * @brief 参数错误
     */
    BIM_PARAMETER_ERROR = 10001,
    /**
     * @brief 数据库错误
     */
    BIM_DB_ERROR = 10002,
    /**
     * @brief 会话不存在
     */
    BIM_CONVERSATION_NOT_EXIST = 10003,
    /**
     * @brief 创建群组成员过少
     */
    BIM_CREATE_GROUP_MEMBER_NOT_ENOUGH = 10004,
    /**
     * @brief 会话拉取中
     */
    BIM_CONVERSATION_LIST_IS_SYNCING = 10005,
    /**
     * @brief 上传失败
     */
    BIM_UPLOAD_FAILED = 10006,
    /**
     * @brief 文件大小超出限制
     */
    BIM_UPLOAD_FILE_SIZE_OUT_LIMIT = 10007,
    /**
     * @brief 重复加入直播群
     */
    BIM_LIVE_GROUP_ALREADY_JOIN = 10008,
    /**
     * @brief 需要先加入一个直播群才能离开
     */
    BIM_LIVE_GROUP_NOT_IN_GROUP = 10009,
    /**
     * @brief SDK 未准备好，请 init 后重试
     */
    BIM_SDK_NOT_READY = 100010,
    /**
     * @brief 迁移下载的临时文件失败
     */
    BIM_DOWNLOAD_FILE_MOVE_FAILED = 10011,
    /**
     * @brief 重复下载URL
     */
    BIM_DOWNLOAD_FILE_DUPLICATE = 10012,
    /**
     * @brief 下载状态码错误
     */
    BIM_DOWNLOAD_STATUS_ERROR = 10013,
    /**
     * @brief 用户不在会话中
     */
    BIM_SERVER_ERROR_SEND_NOT_IN_CONVERSATION = 15001,
    /**
     * @brief 会话被禁言
     */
    BIM_SERVER_ERROR_SEND_CONVERSATION_SILENT = 15002,
    /**
     * @brief 服务回调被拦截
     */
    BIM_SERVER_ERROR_SEND_INTERCEPT_CALLBACK = 15003,
    /**
     * @brief 用户被禁言
     */
    BIM_SERVER_ERROR_SEND_USER_SILENT = 15004,
    /**
     * @brief 当前会话状态错误
     */
    BIM_SERVER_ERROR_SEND_CONVERSATION_STATUS_ERROR = 15005,
    /**
     * @brief 当前会话不存在
     */
    BIM_SERVER_ERROR_SEND_CONVERSATION_NOT_EXIST = 15006,
    /**
     * @brief 服务已拒绝
     */
    BIM_SERVER_ERROR_CREATE_CONVERSATION_REJECT = 15100,
    /**
     * @brief 创建会话时，成员所加入的会话数已达上限
     */
    BIM_SERVER_ERROR_CREATE_CONVERSATION_MORE_THAN_LIMIT = 15101,
    /**
     * @brief 创建直播群超过数量限制
     */
    BIM_SERVER_ERROR_CREATE_LIVE_MORE_THAN_LIMIT = 15102,
    /**
     * @brief 创建会话时，成员数超出限制
     */
    BIM_SERVER_ERROR_CREATE_CONVERSATION_MEMBER_TOUCH_LIMIT = 15103,
    /**
     * @brief 添加成员被服务拒绝
     */
    BIM_SERVER_ADD_MEMBER_REJECT = 15200,
    /**
     * @brief 添加成员部分成员被服务拒绝
     */
    BIM_SERVER_ADD_MEMBER_PART_REJECT = 15201,
    /**
     * @brief 添加成员超出限制
     */
    BIM_SERVER_ADD_MEMBER_TOUCH_LIMIT = 15203,
    /**
     * @brief 添加成员的会话超出限制
     */
    BIM_SERVER_ADD_MEMBER_MORE_THAN_LIMIT = 15204,
    /**
     * @brief 用户在进群黑名单
     */
    BIM_SERVER_ADD_MEMBER_IS_BLOCK = 15205,
    /**
     * @brief 更改角色被服务拒绝
     */
    BIM_SERVER_REMOVE_MEMBER_REJECT = 15300,
    /**
     * @brief 移出成员被服务拒绝
     */
    BIM_SERVER_CHANG_MEMBER_ROLE_REJECT = 15400,
    /**
     * @brief 置顶会话成员被服务拒绝
     */
    BIM_SERVER_STICK_TOP_CONVERSATION_REJECT = 15500,
    /**
     * @brief 设置群信息被服务拒绝
     */
    BIM_SERVER_SET_GROUP_INFO_REJECT = 15600,
    /**
     * @brief 群主转让的成员在黑名单
     */
    BIM_SERVER_SET_OWNER_PARTICIPANT_IS_BLOCK = 15700,
    /**
     * @brief IO 错误
     */
    TTNET_ERR_IO_PENDING = -1,
    /**
     * @brief 失败
     */
    TTNET_ERR_FAILED = -2,
    /**
     * @brief 被终止
     */
    TTNET_ERR_ABORTED = -3,
    /**
     * @brief 参数非法
     */
    TTNET_ERR_INVALID_ARGUMENT = -4,
    /**
     * @brief 非法 handler
     */
    TTNET_ERR_INVALID_HANDLE = -5,
    /**
     * @brief 文件未找到
     */
    TTNET_ERR_FILE_NOT_FOUND = -6,
    /**
     * @brief 超时错误
     */
    TTNET_ERR_TIME_OUT = -7,
    /**
     * @brief 文件过大
     */
    TTNET_ERR_FILE_TOO_BIG = -8,
    /**
     * @brief 出现异常
     */
    TTNET_ERR_UNEXCEPTION = -9,
    /**
     * @brief 禁止访问
     */
    TTNET_ERR_ACCESS_DENIED = -10,
    /**
     * @brief 未实现功能
     */
    TTNET_ERR_NOT_IMPLEMENTED = -11,
    /**
     * @brief 资源不充分
     */
    TTNET_ERR_INSUFFICIENT_RESOURCES = -12,
    /**
     * @brief 内存溢出
     */
    TTNET_ERR_OUT_OF_MEMORY = -13,
    /**
     * @brief 上传文件改变
     */
    TTNET_ERR_UPLOAD_FILE_CHANGED = -14,
    /**
     * @brief 长连接断开
     */
    TTNET_ERR_SOCKET_NOT_CONNECTED = -15,
    /**
     * @brief 文件不存在
     */
    TTNET_ERR_FILE_EXISTS = -16,
    /**
     * @brief 文件路径过长
     */
    TTNET_ERR_FILE_PATH_TOO_LONG = -17,
    /**
     * @brief 没有多余空间
     */
    TTNET_ERR_FILE_NO_SPACE = -18,
    /**
     * @brief 文件病毒错误
     */
    TTNET_ERR_FILE_VIRUS_INFECTED = -19,
    /**
     * @brief 客户端阻塞错误
     */
    TTNET_ERR_BLOCKED_BY_CLIENT = -20,
    /**
     * @brief 网络变化错误
     */
    TTNET_ERR_NETWORK_CHANGED = -21,
    /**
     * @brief 管理员阻塞错误
     */
    TTNET_ERR_BLOCKED_BY_ADMINISTRATOR = -22,
    /**
     * @brief 长连接已经连接
     */
    TTNET_ERR_SOCKET_IS_CONNECTED = -23,
    /**
     * @brief 注册被阻塞错误
     */
    TTNET_ERR_BLOCKED_ENROLLMENT_CHECK_PENDING = -24,
    /**
     * @brief 上传重传不支持
     */
    TTNET_ERR_UPLOAD_STREAM_REWIND_NOT_SUPPORTED = -25,
    /**
     * @brief 上下文已关闭错误
     */
    TTNET_ERR_CONTEXT_SHUT_DOWN = -26,
    /**
     * @brief 返回阻塞错误
     */
    TTNET_ERR_BLOCKED_BY_RESPONSE = -27,
    /**
     * @brief 被 xss 阻塞
     */
    TTNET_ERR_BLOCKED_BY_XSS_AUDITOR = -28,
    /**
     * @brief 无权限错误
     */
    TTNET_ERR_CLEARTEXT_NOT_PERMITTED = -29,
    /**
     * @brief 长连接已关闭
     */
    TTNET_ERR_CONNECTION_CLOSED = -100,
    /**
     * @brief 长连接已重置
     */
    TTNET_ERR_CONNECTION_RESET = -101,
    /**
     * @brief 长连接被拒绝
     */
    TTNET_ERR_CONNECTION_REFUSED = -102,
    /**
     * @brief 长连接被放弃
     */
    TTNET_ERR_CONNECTION_ABORTED = -103,
    /**
     * @brief 长连接失败
     */
    TTNET_ERR_CONNECTION_FAILED = -104,
    /**
     * @brief 未发现名称
     */
    TTNET_ERR_NAME_NOT_RESOLVED = -105,
    /**
     * @brief 网络断开
     */
    TTNET_ERR_INTERNET_DISCONNECTED = -106,
    /**
     * @brief ssl 协议错误
     */
    TTNET_ERR_SSL_PROTOCOL_ERROR = -107,
    /**
     * @brief 地址非法
     */
    TTNET_ERR_ADDRESS_INVALID = -108,
    /**
     * @brief 地址不可访问
     */
    TTNET_ERR_ADDRESS_UNREACHABLE = -109,
    /**
     * @brief 需要 ssl 证书
     */
    TTNET_ERR_SSL_CLIENT_AUTH_CERT_NEEDED = -110,
    /**
     * @brief tunnel 连接错误
     */
    TTNET_ERR_TUNNEL_CONNECTION_FAILED = -111,
    /**
     * @brief 不支持 ssl 版本
     */
    TTNET_ERR_NO_SSL_VERSIONS_ENABLED = -112,
    /**
     * @brief ssl 版本或密码不匹配
     */
    TTNET_ERR_SSL_VERSION_OR_CIPHER_MISMATCH = -113,
    /**
     * @brief ssl 协商错误
     */
    TTNET_ERR_SSL_RENEGOTIATION_REQUESTED = -114,
    /**
     * @brief 代理权限不支持
     */
    TTNET_ERR_PROXY_AUTH_UNSUPPORTED = -115,
    /**
     * @brief ssl 协商证书错误
     */
    TTNET_ERR_CERT_ERROR_IN_SSL_RENEGOTIATION = -116,
    /**
     * @brief ssl 客户端证书错误
     */
    TTNET_ERR_BAD_SSL_CLIENT_AUTH_CERT = -117,
    /**
     * @brief 连接超时
     */
    TTNET_ERR_CONNECTION_TIMED_OUT = -118,
    /**
     * @brief host 队列过长
     */
    TTNET_ERR_HOST_RESOLVER_QUEUE_TOO_LARGE = -119,
    /**
     * @brief 连接失败
     */
    TTNET_ERR_SOCKS_CONNECTION_FAILED = -120,
    /**
     * @brief 连接不可用
     */
    TTNET_ERR_SOCKS_CONNECTION_HOST_UNREACHABLE = -121,
    /**
     * @brief 协商错误
     */
    TTNET_ERR_ALPN_NEGOTIATION_FAILED = -122,
    /**
     * @brief ssl 未协商
     */
    TTNET_ERR_SSL_NO_RENEGOTIATION = -123,
    /**
     * @brief 读写字节异常
     */
    TTNET_ERR_WINSOCK_UNEXPECTED_WRITTEN_BYTES = -124,
    /**
     * @brief ssl 异常
     */
    TTNET_ERR_SSL_DECOMPRESSION_FAILURE_ALERT = -125,
    /**
     * @brief ssl 异常
     */
    TTNET_ERR_SSL_BAD_RECORD_MAC_ALERT = -126,
    /**
     * @brief 代理无权限
     */
    TTNET_ERR_PROXY_AUTH_REQUESTED = -127,
    /**
     * @brief ssl dh 密钥错误
     */
    TTNET_ERR_SSL_WEAK_SERVER_EPHEMERAL_DH_KEY = -129,
    /**
     * @brief 代理连接错误
     */
    TTNET_ERR_PROXY_CONNECTION_FAILED = -130,
    /**
     * @brief 强制代理配置错误
     */
    TTNET_ERR_MANDATORY_PROXY_CONFIGURATION_FAILED = -131,
    /**
     * @brief 连接超出限制
     */
    TTNET_ERR_PRECONNECT_MAX_SOCKET_LIMIT = -133,
    /**
     * @brief ssl 客户端密钥非法
     */
    TTNET_ERR_SSL_CLIENT_AUTH_PRIVATE_KEY_ACCESS_DENIED = -134,
    /**
     * @brief ssl 客户端证书非私有
     */
    TTNET_ERR_SSL_CLIENT_AUTH_CERT_NO_PRIVATE_KEY = -135,
    /**
     * @brief 代理证书错误
     */
    TTNET_ERR_PROXY_CERTIFICATE_INVALID = -136,
    /**
     * @brief 名称非法
     */
    TTNET_ERR_NAME_RESOLUTION_FAILED = -137,
    /**
     * @brief 网络被禁用
     */
    TTNET_ERR_NETWORK_ACCESS_DENIED = -138,
    /**
     * @brief 被节流
     */
    TTNET_ERR_TEMPORARILY_THROTTLED = -139,
    /**
     * @brief 代理错误
     */
    TTNET_ERR_HTTPS_PROXY_TUNNEL_RESPONSE = -140,
    /**
     * @brief ssl 客户端签名失败
     */
    TTNET_ERR_SSL_CLIENT_AUTH_SIGNATURE_FAILED = -141,
    /**
     * @brief 消息过大
     */
    TTNET_ERR_MSG_TOO_BIG = -142,
    /**
     * @brief spdu 已经存在
     */
    TTNET_ERR_SPDY_SESSION_ALREADY_EXISTS = -143,
    /**
     * @brief ws 协议错误
     */
    TTNET_ERR_WS_PROTOCOL_ERROR = -145,
    /**
     * @brief 地址被占用
     */
    TTNET_ERR_ADDRESS_IN_USE = -147,
    /**
     * @brief ssl 握手未完成
     */
    TTNET_ERR_SSL_HANDSHAKE_NOT_COMPLETED = -148,
    /**
     * @brief ssl 公钥错误
     */
    TTNET_ERR_SSL_BAD_PEER_PUBLIC_KEY = -149,
    /**
     * @brief ssl 收藏密钥不在密钥链
     */
    TTNET_ERR_SSL_PINNED_KEY_NOT_IN_CERT_CHAIN = -150,
    /**
     * @brief 客户端证书不支持
     */
    TTNET_ERR_CLIENT_AUTH_CERT_TYPE_UNSUPPORTED = -151,
    /**
     * @brief 证书类型不匹配
     */
    TTNET_ERR_ORIGIN_BOUND_CERT_GENERATION_TYPE_MISMATCH = -152,
    /**
     * @brief ssl 解密错误
     */
    TTNET_ERR_SSL_DECRYPT_ERROR_ALERT = -153,
    /**
     * @brief ws 节流队列过长
     */
    TTNET_ERR_WS_THROTTLE_QUEUE_TOO_LARGE = -154,
    /**
     * @brief ssl 服务证书变更
     */
    TTNET_ERR_SSL_SERVER_CERT_CHANGED = -156,
    /**
     * @brief 未识别名称
     */
    TTNET_ERR_SSL_UNRECOGNIZED_NAME_ALERT = -159,
    /**
     * @brief socket 设置接收缓冲区错误
     */
    TTNET_ERR_SOCKET_SET_RECEIVE_BUFFER_SIZE_ERROR = -160,
    /**
     * @brief socket 设置发送缓冲区错误
     */
    TTNET_ERR_SOCKET_SET_SEND_BUFFER_SIZE_ERROR = -161,
    /**
     * @brief socket 接收缓冲区无法使用
     */
    TTNET_ERR_SOCKET_RECEIVE_BUFFER_SIZE_UNCHANGEABLE = -162,
    /**
     * @brief socket 发送缓冲区无法使用
     */
    TTNET_ERR_SOCKET_SEND_BUFFER_SIZE_UNCHANGEABLE = -163,
    /**
     * @brief ssl 客户端证书格式化错误
     */
    TTNET_ERR_SSL_CLIENT_AUTH_CERT_BAD_FORMAT = -164,
    /**
     * @brief icann 名称冲突
     */
    TTNET_ERR_ICANN_NAME_COLLISION = -166,
    /**
     * @brief ssl 服务证书格式化错误
     */
    TTNET_ERR_SSL_SERVER_CERT_BAD_FORMAT = -167,
    /**
     * @brief ct sth 解析错误
     */
    TTNET_ERR_CT_STH_PARSING_FAILED = -168,
    /**
     * @brief ct sth 解析未完成
     */
    TTNET_ERR_CT_STH_INCOMPLETE = -169,
    /**
     * @brief 无法重用代理身份验证的连接
     */
    TTNET_ERR_UNABLE_TO_REUSE_CONNECTION_FOR_PROXY_AUTH = -170,
    /**
     * @brief ct 一致性验证解析失败
     */
    TTNET_ERR_CT_CONSISTENCY_PROOF_PARSING_FAILED = -171,
    /**
     * @brief ssl 密码过期
     */
    TTNET_ERR_SSL_OBSOLETE_CIPHER = -172,
    /**
     * @brief ws 升级
     */
    TTNET_ERR_WS_UPGRADE = -173,
    /**
     * @brief ttnet 请求超时
     */
    TTNET_ERR_TTNET_REQUEST_TIMED_OUT = -192,
    /**
     * @brief ttnet 连接超时
     */
    TTNET_ERR_TTNET_SOCKET_CONNECTION_TIMEOUT = -13,
    /**
     * @brief ttnet socket 读数据超时
     */
    TTNET_ERR_TTNET_SOCKET_READ_TIMEOUT = -194,
    /**
     * @brief ttnet socket 写数据超时
     */
    TTNET_ERR_TTNET_SOCKET_WRITE_TIMEOUT = -195,
    /**
     * @brief ttnet 不支持的重定向
     */
    TTNET_ERR_TTNET_UNSUPPORTED_REDIRECT = -196,
    /**
     * @brief ttnet 上传异常
     */
    TTNET_ERR_TTNET_APP_UPLOAD_EXCEPTION = -197,
    /**
     * @brief ttnet 连接超时
     */
    TTNET_ERR_TTNET_CONNECTION_TIMED_OUT = -198,
    /**
     * @brief ttnet 客户端超时
     */
    TTNET_ERR_TTNET_APP_TIMED_OUT = -199,
    /**
     * @brief 证书通用名称非法
     */
    TTNET_ERR_CERT_COMMON_NAME_INVALID = -200,
    /**
     * @brief 证书数据非法
     */
    TTNET_ERR_CERT_DATE_INVALID = -201,
    /**
     * @brief 证书权限非法
     */
    TTNET_ERR_CERT_AUTHORITY_INVALID = -202,
    /**
     * @brief 证书中包含错误
     */
    TTNET_ERR_CERT_CONTAINS_ERRORS = -203,
    /**
     * @brief 证书无撤销机制
     */
    TTNET_ERR_CERT_NO_REVOCATION_MECHANISM = -204,
    /**
     * @brief 证书无法检查吊销
     */
    TTNET_ERR_CERT_UNABLE_TO_CHECK_REVOCATION = -205,
    /**
     * @brief 证书已撤销
     */
    TTNET_ERR_CERT_REVOKED = -206,
    /**
     * @brief 证书非法
     */
    TTNET_ERR_CERT_INVALID = -207,
    /**
     * @brief 弱签名算法
     */
    TTNET_ERR_CERT_WEAK_SIGNATURE_ALGORITHM = -208,
    /**
     * @brief 证书非唯一名称
     */
    TTNET_ERR_CERT_NON_UNIQUE_NAME = -210,
    /**
     * @brief 证书弱密钥
     */
    TTNET_ERR_CERT_WEAK_KEY = -211,
    /**
     * @brief 违反证书名称约束
     */
    TTNET_ERR_CERT_NAME_CONSTRAINT_VIOLATION = -212,
    /**
     * @brief 证书有效期过长
     */
    TTNET_ERR_CERT_VALIDITY_TOO_LONG = -213,
    /**
     * @brief 需要证书透明度
     */
    TTNET_ERR_CERTIFICATE_TRANSPARENCY_REQUIRED = -214,
    /**
     * @brief 证书结束
     */
    TTNET_ERR_CERT_END = -215,
    /**
     * @brief 非法 url
     */
    TTNET_ERR_INVALID_URL = -300,
    /**
     * @brief 非法 scheme
     */
    TTNET_ERR_DISALLOWED_URL_SCHEME = -301,
    /**
     * @brief 未知 scheme
     */
    TTNET_ERR_UNKNOWN_URL_SCHEME = -302,
    /**
     * @brief 重定向过多
     */
    TTNET_ERR_TOO_MANY_REDIRECTS = -310,
    /**
     * @brief 不安全的重定向
     */
    TTNET_ERR_UNSAFE_REDIRECT = -311,
    /**
     * @brief 不安全的端口
     */
    TTNET_ERR_UNSAFE_PORT = -312,
    /**
     * @brief 非法返回
     */
    TTNET_ERR_INVALID_RESPONSE = -320,
    /**
     * @brief 无效的分块编码
     */
    TTNET_ERR_INVALID_CHUNKED_ENCODING = -321,
    /**
     * @brief 方法不支持
     */
    TTNET_ERR_METHOD_NOT_SUPPORTED = -322,
    /**
     * @brief 意外的代理身份验证
     */
    TTNET_ERR_UNEXPECTED_PROXY_AUTH = -323,
    /**
     * @brief 空返回错误
     */
    TTNET_ERR_EMPTY_RESPONSE = -324,
    /**
     * @brief 返回体中 headers 太大
     */
    TTNET_ERR_RESPONSE_HEADERS_TOO_BIG = -325,
    /**
     * @brief pac 状态错误
     */
    TTNET_ERR_PAC_STATUS_NOT_OK = -326,
    /**
     * @brief pac 脚本错误
     */
    TTNET_ERR_PAC_SCRIPT_FAILED = -327,
    /**
     * @brief 请求范围不可满足
     */
    TTNET_ERR_REQUEST_RANGE_NOT_SATISFIABLE = -328,
    /**
     * @brief 身份不正确
     */
    TTNET_ERR_MALFORMED_IDENTITY = -329,
    /**
     * @brief 内容解码失败
     */
    TTNET_ERR_CONTENT_DECODING_FAILED = -330,
    /**
     * @brief 网络 io 已暂停
     */
    TTNET_ERR_NETWORK_IO_SUSPENDED = -331,
    /**
     * @brief 未收到 syn 回复
     */
    TTNET_ERR_SYN_REPLY_NOT_RECEIVED = -332,
    /**
     * @brief 对对话进行编码失败
     */
    TTNET_ERR_ENCODING_CONVERSION_FAILED = -333,
    /**
     * @brief 无法识别的 ftp 目录列表格式
     */
    TTNET_ERR_UNRECOGNIZED_FTP_DIRECTORY_LISTING_FORMAT = -334,
    /**
     * @brief 无效 spdy 流
     */
    TTNET_ERR_INVALID_SPDY_STREAM = -335,
    /**
     * @brief 没有支持的代理
     */
    TTNET_ERR_NO_SUPPORTED_PROXIES = -336,
    /**
     * @brief spdy 协议错误
     */
    TTNET_ERR_SPDY_PROTOCOL_ERROR = -337,
    /**
     * @brief 无效的身份验证凭据
     */
    TTNET_ERR_INVALID_AUTH_CREDENTIALS = -338,
    /**
     * @brief 不支持的身份验证方案
     */
    TTNET_ERR_UNSUPPORTED_AUTH_SCHEME = -339,
    /**
     * @brief 编码检测失败
     */
    TTNET_ERR_ENCODING_DETECTION_FAILED = -340,
    /**
     * @brief 缺少身份验证凭据
     */
    TTNET_ERR_MISSING_AUTH_CREDENTIALS = -341,
    /**
     * @brief 意外的安全库状态
     */
    TTNET_ERR_UNEXPECTED_SECURITY_LIBRARY_STATUS = -342,
    /**
     * @brief 配置错误的身份验证环境
     */
    TTNET_ERR_MISCONFIGURED_AUTH_ENVIRONMENT = -343,
    /**
     * @brief 取消文档安全库状态
     */
    TTNET_ERR_UNDOCUMENTED_SECURITY_LIBRARY_STATUS = -344,
    /**
     * @brief 响应体太大
     */
    TTNET_ERR_RESPONSE_BODY_TOO_BIG_TO_DRAIN = -345,
    /**
     * @brief 响应 headers 多个内容长度
     */
    TTNET_ERR_RESPONSE_HEADERS_MULTIPLE_CONTENT_LENGTH = -346,
    /**
     * @brief 不完整的 spdy headers
     */
    TTNET_ERR_INCOMPLETE_SPDY_HEADERS = -347,
    /**
     * @brief pac 不在 dhcp 中
     */
    TTNET_ERR_PAC_NOT_IN_DHCP = -348,
    /**
     * @brief 响应标头多重内容处置
     */
    TTNET_ERR_RESPONSE_HEADERS_MULTIPLE_CONTENT_DISPOSITION = -349,
    /**
     * @brief 多个位置的响应标头
     */
    TTNET_ERR_RESPONSE_HEADERS_MULTIPLE_LOCATION = -350,
    /**
     * @brief spdy 服务器拒绝流
     */
    TTNET_ERR_SPDY_SERVER_REFUSED_STREAM = -351,
    /**
     * @brief spdy ping 失败
     */
    TTNET_ERR_SPDY_PING_FAILED = -352,
    /**
     * @brief 内容长度不匹配
     */
    TTNET_ERR_CONTENT_LENGTH_MISMATCH = -354,
    /**
     * @brief 不完全分块编码
     */
    TTNET_ERR_INCOMPLETE_CHUNKED_ENCODING = -355,
    /**
     * @brief quic 协议错误
     */
    TTNET_ERR_QUIC_PROTOCOL_ERROR = -356,
    /**
     * @brief 响应 headers 被截断
     */
    TTNET_ERR_RESPONSE_HEADERS_TRUNCATED = -357,
    /**
     * @brief quick 握手失败
     */
    TTNET_ERR_QUIC_HANDSHAKE_FAILED = -358,
    /**
     * @brief spdy 安全性不足
     */
    TTNET_ERR_SPDY_INADEQUATE_TRANSPORT_SECURITY = -360,
    /**
     * @brief spdy 流量控制错误
     */
    TTNET_ERR_SPDY_FLOW_CONTROL_ERROR = -361,
    /**
     * @brief spdy 帧大小错误
     */
    TTNET_ERR_SPDY_FRAME_SIZE_ERROR = -362,
    /**
     * @brief spdy 压缩错误
     */
    TTNET_ERR_SPDY_COMPRESSION_ERROR = -363,
    /**
     * @brief 请求的代理身份验证没有连接
     */
    TTNET_ERR_PROXY_AUTH_REQUESTED_WITH_NO_CONNECTION = -364,
    /**
     * @brief 需要 http 1.1
     */
    TTNET_ERR_HTTP_1_1_REQUIRED = -365,
    /**
     * @brief 需要代理 http 11
     */
    TTNET_ERR_PROXY_HTTP_1_1_REQUIRED = -366,
    /**
     * @brief pac 脚本已终止
     */
    TTNET_ERR_PAC_SCRIPT_TERMINATED = -367,
    /**
     * @brief 无效的 http 响应
     */
    TTNET_ERR_INVALID_HTTP_RESPONSE = -370,
    /**
     * @brief 内容解码初始化失败
     */
    TTNET_ERR_CONTENT_DECODING_INIT_FAILED = -371,
    /**
     * @brief spdy rst 流未接收到错误
     */
    TTNET_ERR_SPDY_RST_STREAM_NO_ERROR_RECEIVED = -372,
    /**
     * @brief 缓存未命中
     */
    TTNET_ERR_CACHE_MISS = -400,
    /**
     * @brief 读取失败
     */
    TTNET_ERR_CACHE_READ_FAILURE = -401,
    /**
     * @brief 高速缓存写入失败
     */
    TTNET_ERR_CACHE_WRITE_FAILURE = -402,
    /**
     * @brief 不支持缓存操作
     */
    TTNET_ERR_CACHE_OPERATION_NOT_SUPPORTED = -403,
    /**
     * @brief 高速缓存打开故障
     */
    TTNET_ERR_CACHE_OPEN_FAILURE = -404,
    /**
     * @brief 缓存创建失败
     */
    TTNET_ERR_CACHE_CREATE_FAILURE = -405,
    /**
     * @brief 高速缓存竞争
     */
    TTNET_ERR_CACHE_RACE = -406,
    /**
     * @brief 缓存校验和读取失败
     */
    TTNET_ERR_CACHE_CHECKSUM_READ_FAILURE = -407,
    /**
     * @brief 缓存校验和不匹配
     */
    TTNET_ERR_CACHE_CHECKSUM_MISMATCH = -408,
    /**
     * @brief 缓存锁定超时
     */
    TTNET_ERR_CACHE_LOCK_TIMEOUT = -409,
    /**
     * @brief 读取后缓存身份验证失败
     */
    TTNET_ERR_CACHE_AUTH_FAILURE_AFTER_READ = -410,
    /**
     * @brief 不安全响应
     */
    TTNET_ERR_INSECURE_RESPONSE = -501,
    /**
     * @brief 没有证书的私钥
     */
    TTNET_ERR_NO_PRIVATE_KEY_FOR_CERT = -502,
    /**
     * @brief 添加用户证书失败
     */
    TTNET_ERR_ADD_USER_CERT_FAILED = -503,
    /**
     * @brief ttnet 流量控制中断
     */
    TTNET_ERR_TTNET_TRAFFIC_CONTROL_DROP = -555,
    /**
     * @brief ftp 失败
     */
    TTNET_ERR_FTP_FAILED = -601,
    /**
     * @brief ftp 服务不可用
     */
    TTNET_ERR_FTP_SERVICE_UNAVAILABLE = -602,
    /**
     * @brief ftp 传输中止
     */
    TTNET_ERR_FTP_TRANSFER_ABORTED = -603,
    /**
     * @brief ftp 文件正忙
     */
    TTNET_ERR_FTP_FILE_BUSY = -604,
    /**
     * @brief ftp 语法错误
     */
    TTNET_ERR_FTP_SYNTAX_ERROR = -605,
    /**
     * @brief ftp 命令不支持
     */
    TTNET_ERR_FTP_COMMAND_NOT_SUPPORTED = -606,
    /**
     * @brief ftp 错误的命令序列
     */
    TTNET_ERR_FTP_BAD_COMMAND_SEQUENCE = -607,
    /**
     * @brief pkcs12 导入错误密码
     */
    TTNET_ERR_PKCS12_IMPORT_BAD_PASSWORD = -701,
    /**
     * @brief plcs12 导入错误
     */
    TTNET_ERR_PKCS12_IMPORT_FAILED = -702,
    /**
     * @brief 导入 ca 证书错误
     */
    TTNET_ERR_IMPORT_CA_CERT_NOT_CA = -703,
    /**
     * @brief 导入证书已存在
     */
    TTNET_ERR_IMPORT_CERT_ALREADY_EXISTS = -704,
    /**
     * @brief 导入 ca 证书失败
     */
    TTNET_ERR_IMPORT_CA_CERT_FAILED = -705,
    /**
     * @brief 导入服务器证书失败
     */
    TTNET_ERR_IMPORT_SERVER_CERT_FAILED = -706,
    /**
     * @brief pkcs12 导入无效
     */
    TTNET_ERR_PKCS12_IMPORT_INVALID_MAC = -707,
    /**
     * @brief pkcs12 导入文件失败
     */
    TTNET_ERR_PKCS12_IMPORT_INVALID_FILE = -708,
    /**
     * @brief plcs12 不支持导入
     */
    TTNET_ERR_PKCS12_IMPORT_UNSUPPORTED = -709,
    /**
     * @brief 密钥生成失败
     */
    TTNET_ERR_KEY_GENERATION_FAILED = -710,
    /**
     * @brief 私钥导出失败
     */
    TTNET_ERR_PRIVATE_KEY_EXPORT_FAILED = -712,
    /**
     * @brief 自签名证书生成失败
     */
    TTNET_ERR_SELF_SIGNED_CERT_GENERATION_FAILED = -713,
    /**
     * @brief 证书数据库已更改
     */
    TTNET_ERR_CERT_DATABASE_CHANGED = -714,
    /**
     * @brief dns格式错误的响应
     */
    TTNET_ERR_DNS_MALFORMED_RESPONSE = -800,
    /**
     * @brief dns 服务器需要 TCP
     */
    TTNET_ERR_DNS_SERVER_REQUIRES_TCP = -801,
    /**
     * @brief dns 服务失败
     */
    TTNET_ERR_DNS_SERVER_FAILED = -802,
    /**
     * @brief dns 超时
     */
    TTNET_ERR_DNS_TIMED_OUT = -803,
    /**
     * @brief dns 缓存未命中
     */
    TTNET_ERR_DNS_CACHE_MISS = -804,
    /**
     * @brief dns 搜索为空
     */
    TTNET_ERR_DNS_SEARCH_EMPTY = -805,
    /**
     * @brief dns 排序错误
     */
    TTNET_ERR_DNS_SORT_ERROR = -806,
    /**
     * @brief dns 入口陈旧
     */
    TTNET_ERR_DNS_ENTRY_STALE = -807
}

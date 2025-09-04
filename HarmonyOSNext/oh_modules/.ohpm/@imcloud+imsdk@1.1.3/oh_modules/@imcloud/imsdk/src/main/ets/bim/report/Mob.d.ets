export declare class Mob {
    /**
     * 长连接状态
     */
    static readonly EVENT_IM_SDK_FRONTIER_WS_STATE = "imsdk_frontier_ws_state";
    /**
     * 长连接建联
     */
    static readonly EVENT_IM_SDK_FRONTIER_WS_CONNECT = "imsdk_frontier_ws_connect";
    /**
     * 发送消息
     */
    static readonly IMSDK_SEND_MSG = "imsdk_send_msg";
    /**
     * 接收消息
     */
    static readonly IMSDK_RECEIVE_MSG = "imsdk_recieve_msg";
    /**
     * 网络请求成功率
     */
    static readonly IMSDK_NETWORK_REQUEST = "imsdk_network_request";
    /**
     * 消息完整性检查
     */
    static readonly EVENT_PULLER_CHECK_MSG = "imsdk_puller_check_msg_and";
    /**
     * 数据库升级
     */
    static readonly IMSDK_DB_UPDATE_ERR = "imsdk_db_update_err";
    /**
     * 直播群消息完整性
     */
    static readonly LIVE_GROUP_CHECK_MSG = "imsdk_live_group_check_msg";
    static readonly CONVERSATION_TYPE = "conversation_type";
    static readonly DURATION = "duration";
    static readonly CONVERSATION_ID = "conversation_id";
    /**
     * 直播群收消息
     */
    static readonly LIVE_RECEIVE_MSG = "imsdk_recieve_msg_live";
    static readonly MSG_UUID = "msg_uuid";
    static readonly RESULT = "result";
    static readonly MSG_TYPE = "msg_type";
    static readonly IS_BACKGROUND = "is_background";
    static readonly IS_CONNECTED = "is_connected";
    static readonly NET_CONNECTED = "net_connected";
    /**
     * 直播群发消息
     */
    static readonly LIVE_SEND_MSG = "imsdk_send_msg_live";
    static readonly UUID = "uuid";
    static readonly IMSDK_RESULT = "imsdk_result";
    static readonly IM_STATUS_CODE = "im_status_code";
    static readonly ERROR_CODE = "error_code";
}

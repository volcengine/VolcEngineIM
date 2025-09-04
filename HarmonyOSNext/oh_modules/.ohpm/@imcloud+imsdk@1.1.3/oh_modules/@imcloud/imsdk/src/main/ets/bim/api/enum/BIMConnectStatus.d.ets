/**
 * @detail keytype
 * @brief 长连接状态码
 */
export declare enum BIMConnectStatus {
    /**
     * @hidden
     * @brief 未知状态
     */
    BIM_CONNECT_STATUS_UNKNOWN = 1,
    /**
     * @brief 连接中
     */
    BIM_CONNECT_STATUS_CONNECTING = 2,
    /**
     * @brief 连接失败
     */
    BIM_CONNECT_STATUS_FAILED = 4,
    /**
     * @brief 连接关闭
     */
    BIM_CONNECT_STATUS_CLOSED = 8,
    /**
     * @brief 连接成功
     */
    BIM_CONNECT_STATUS_CONNECTED = 16
}

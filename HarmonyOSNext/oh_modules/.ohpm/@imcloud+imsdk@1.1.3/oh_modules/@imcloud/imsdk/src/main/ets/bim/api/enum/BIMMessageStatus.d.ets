/**
 * @detail keytype
 * @brief 消息发送状态
 */
export declare enum BIMMessageStatus {
    /**
     * @hidden
     * @brief 未知状态
     */
    BIM_MESSAGE_STATUS_UNKNOWN = -1,
    /**
     * @brief 发送等待, 消息只添加数据库
     */
    BIM_MESSAGE_STATUS_PENDING = 0,
    /**
     * @brief 发送中
     */
    BIM_MESSAGE_STATUS_SENDING = 1,
    /**
     * @brief 发送成功
     */
    BIM_MESSAGE_STATUS_SUCCESS = 2,
    /**
     * @brief 发送失败
     */
    BIM_MESSAGE_STATUS_FAILED = 3,
    /**
     * @brief 正在上传消息的文件部分。
     */
    BIM_MESSAGE_STATUS_SENDING_FILE_PARTS = 4,
    /**
     * @brief 收到的消息或是拉取到的发送消息
     */
    BIM_MESSAGE_STATUS_NORMAL = 5
}

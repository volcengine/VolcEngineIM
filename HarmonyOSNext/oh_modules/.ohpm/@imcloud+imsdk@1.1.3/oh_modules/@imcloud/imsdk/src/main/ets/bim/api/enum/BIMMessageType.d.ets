/**
 * @detail keytype
 * @brief 消息类型
 */
export declare enum BIMMessageType {
    /**
     * @hidden
     * @brief 未知类型
     */
    BIM_MESSAGE_TYPE_UNKNOWN = -1,
    /**
     * @brief 文本消息
     */
    BIM_MESSAGE_TYPE_TEXT = 10001,
    /**
     * @brief 图片消息
     */
    BIM_MESSAGE_TYPE_IMAGE = 10003,
    /**
     * @brief 视频消息
     */
    BIM_MESSAGE_TYPE_VIDEO = 10004,
    /**
     * @brief 文件消息
     */
    BIM_MESSAGE_TYPE_FILE = 10005,
    /**
     * @brief 语音消息
     */
    BIM_MESSAGE_TYPE_AUDIO = 10006,
    /**
     * @brief 自定义消息
     */
    BIM_MESSAGE_TYPE_CUSTOM = 10012
}

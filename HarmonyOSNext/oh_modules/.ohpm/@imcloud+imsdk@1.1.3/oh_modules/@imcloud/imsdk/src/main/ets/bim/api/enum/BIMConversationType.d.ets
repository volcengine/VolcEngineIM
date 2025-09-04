/**
 * @detail keytype
 * @brief 会话类型
 */
export declare enum BIMConversationType {
    /**
     * @hidden
     */
    BIM_CONVERSATION_TYPE_UNKNOWN = -1,
    /**
     * @brief 单聊会话
     */
    BIM_CONVERSATION_TYPE_ONE_CHAT = 1,
    /**
     * @brief 群聊会话
     */
    BIM_CONVERSATION_TYPE_GROUP_CHAT = 2,
    /**
     * @hidden 轻直播会话
     */
    BIM_CONVERSATION_TYPE_LITE_LIVE_CHAT = 3,
    /**
     * @brief 直播群
     */
    BIM_CONVERSATION_TYPE_LIVE_CHAT = 100
}

/**
 * @hidden
 * @detail keytype
 * @brief 直播群成员标记类型更新信息
 */
export declare class BIMLiveGroupMarkTypeChangeInfo {
    /**
     * @hidden
     */
    private operatorUid;
    /**
     * @hidden
     */
    private operatorUidString;
    /**
     * @hidden
     */
    private markTypeList;
    /**
     * @hidden
     */
    private conversationShortId;
    /**
     * @return 操作用户的uid
     * @detail api
     * @brief 获取操作用户的uid
     */
    getOperatorUid(): string;
    /**
     * @hidden
     */
    setOperatorUid(operatorUid: string): void;
    /**
     * @return 标记类型列表
     * @detail api
     * @brief 获取标记类型列表
     */
    getMarkType(): string[];
    /**
     * @hidden
     */
    setMarkType(markTypeList: string[]): void;
    /**
     * @hidden
     */
    setConversationShortId(conversationShortId: string): void;
    /**
     * @return 标记变更会话short id
     * @detail api
     * @brief 获取标记变更会话short id
     */
    getConversationShortId(): string;
    /** @hidden */
    getOperatorUidString(): string;
    /** @hidden */
    setOperatorUidString(operatorUidString: string): void;
}

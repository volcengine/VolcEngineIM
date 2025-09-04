import { BIMConversation } from "../../../../../../Index";
/**
 * @detail keytype
 * @brief 加入直播群返回
 */
export declare class BIMLiveJoinGroupResult {
    /**
     * @hidden
     */
    private conversation;
    /**
     * @hidden
     */
    private joinMessageCursor;
    /**
     * @hidden
     */
    constructor(conversation: BIMConversation, joinMessageCursor: number);
    /**
     * @detail api
     * @brief 获取加入的会话
     * @return 获取加入的会话, 参看 BIMConversation{@link #BIMConversation}
     */
    getConversation(): BIMConversation | undefined;
    /**
     * @hidden
     */
    setConversation(conversation: BIMConversation): void;
    /**
     * @detail api
     * @brief 获取加入的会话时最新一条消息 Cursor，通过此游标拉取直播群历史消息
     * @return 获取加入的会话时最新一条消息, 参看 BIMConversation{@link #BIMConversation}
     */
    getJoinMessageCursor(): number;
    /**
     * @hidden
     */
    setJoinMessageCursor(joinMessageCursor: number): void;
}

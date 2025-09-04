import { BIMBlockStatus, BIMConversation, BIMMember } from "../../../../../../Index";
/**
 * @detail callback
 * @brief 直播群成员事件回调监听方。
 */
export interface BIMLiveGroupMemberEventListener {
    /**
     * @param conversation 会话信息, 参看 BIMConversation{@link #BIMConversation}。
     * @param memberList   成员列表,参看 BIMMember{@link #BIMMember}。
     * @detail callback
     * @brief 成员加入群聊。
     */
    onMemberJoined: (conversation: BIMConversation, memberList: BIMMember[]) => void;
    /**
     * @param conversation 会话信息, 参看 BIMConversation{@link #BIMConversation}。
     * @param memberList   成员列表,参看 BIMMember{@link #BIMMember}。
     * @detail callback
     * @brief 成员退出群聊。
     */
    onMemberLeave: (conversation: BIMConversation, memberList: BIMMember[]) => void;
    /**
     * @param conversation 会话信息, 参看 BIMConversation{@link #BIMConversation}。
     * @param memberList   成员列表,参看 BIMMember{@link #BIMMember}。
     * @param operatorID   操作用户 ID
     * @detail callback
     * @brief 成员被踢出直播群。
     */
    onMemberKicked: (conversation: BIMConversation, memberList: BIMMember[], operatorID: string) => void;
    /**
     * @param conversation 会话信息, 参看 BIMConversation{@link #BIMConversation}。
     * @param fromUID      旧群主 UID。
     * @param toUID        新群主 UID。
     * @detail callback
     * @brief 群主发生变化。
     */
    onMemberOwnerChanged: (conversation: BIMConversation, fromUID: string, toUID: string) => void;
    /**
     * @param conversation     会话信息, 参看 BIMConversation{@link #BIMConversation}。
     * @param memberSilentList 禁言、取消成员列表
     * @param status           禁言状态，参看 BIMBlockStatus{@link #BIMBlockStatus}。
     * @param operatorId       操作用户 ID
     * @detail callback
     * @brief 群成员被禁言。
     */
    onMemberSilent: (conversation: BIMConversation, memberSilentList: BIMMember[], status: BIMBlockStatus, operatorId: string) => void;
    /**
     * @param conversation 会话信息, 参看 BIMConversation{@link #BIMConversation}。
     * @param status       禁言状态，参看 BIMBlockStatus{@link #BIMBlockStatus}。
     * @param operatorId   操作用户 ID。
     * @detail callback
     * @brief 禁言、取消会话:(禁言、取消所有人)。
     */
    onAllMemberSilent: (conversation: BIMConversation, status: BIMBlockStatus, operatorId: string) => void;
    /**
     * @param conversation 会话信息, 参看 BIMConversation{@link #BIMConversation}。
     * @param adminList    添加的管理员列表，参看 BIMMember{@link #BIMMember}。
     * @param operatorId   操作用户 ID。
     * @detail callback
     * @brief 添加管理员。
     */
    onAddAdmin: (conversation: BIMConversation, adminList: BIMMember[], operatorId: string) => void;
    /**
     * @param conversation 会话信息, 参看 BIMConversation{@link #BIMConversation}。
     * @param uidList      移出的管理员列表，参看 BIMMember{@link #BIMMember}。
     * @param operatorId   操作用户 ID。
     * @detail callback
     * @brief 添加管理员移除管理员。
     */
    onRemoveAdmin: (conversation: BIMConversation, uidList: BIMMember[], operatorId: string) => void;
    /**
     * @param conversation 会话信息，参看 BIMConversation{@link #BIMConversation}。
     * @param member       变更的群成员信息，参看 BIMMember{@link #BIMMember}。
     * @detail callback
     * @brief 成员信息变更。
     */
    onMemberInfoChanged: (conversation: BIMConversation, member: BIMMember) => void;
    /**
     * @param conversation 会话信息，参看 BIMConversation{@link #BIMConversation}。
     * @param members      批量变更的群成员信息，参看 BIMMember{@link #BIMMember}。
     * @detail callback
     * @brief 批量成员信息变更。
     */
    onBatchMemberInfoChanged: (conversation: BIMConversation, members: BIMMember[]) => void;
}

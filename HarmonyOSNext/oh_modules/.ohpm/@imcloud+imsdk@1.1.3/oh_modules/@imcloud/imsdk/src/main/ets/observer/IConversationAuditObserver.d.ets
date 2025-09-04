import { im_proto } from '../api/proto';
export interface IConversationAuditObserver {
    /**
     *  进群申请 - push 建群提示复用这个命令消息
     */
    onNewConversationApply?: (notifyInfo: im_proto.ConversationApplyInfo, unreadCount: bigint) => void;
    /**
     *  审核进群申请 - push
     */
    onNewApplyAck?: (notifyInfo: im_proto.ConversationApplyInfo) => void;
}

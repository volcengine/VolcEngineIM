import { im_proto } from '../../proto/index';
export declare class ConversationApplyAckResult {
    /**
     * 具体业务body里的status
     */
    status?: number | undefined;
    applyInfo?: im_proto.IConversationApplyInfo | undefined;
}

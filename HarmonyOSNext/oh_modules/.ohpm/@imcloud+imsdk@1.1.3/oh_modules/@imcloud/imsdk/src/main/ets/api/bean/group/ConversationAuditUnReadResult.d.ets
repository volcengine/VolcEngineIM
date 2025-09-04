import { im_proto } from '../../proto/index';
export declare class ConversationAuditUnReadResult {
    unreadCount?: bigint;
    lastDeleteTs?: bigint;
    status?: number;
    unreadConversationApply?: Map<bigint, bigint>;
    ext?: Map<string, string>;
    applyInfo?: im_proto.IConversationApplyInfo | undefined;
}

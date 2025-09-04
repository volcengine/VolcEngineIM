/** 进群审批 */
import { im_proto } from '../../proto/index';
export declare class ConversationAuditListResult {
    nextCursor?: bigint;
    applyInfoList: im_proto.IConversationApplyInfo[] | undefined;
    hasMore: boolean | undefined;
}

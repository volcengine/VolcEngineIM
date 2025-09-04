/**
 * ConversationModel：获取会话相关的数据和操作
 */
import { IMResult } from '../api/bean/IMHandlerResult';
import { ConversationApplyAckResult } from '../api/bean/group/ConversationApplyAckResult';
import { ConversationAuditListResult } from '../api/bean/group/ConversationAuditListResult';
import { ConversationAuditSwitchResult } from '../api/bean/group/ConversationAuditSwitchResult';
import { ConversationAuditUnReadResult } from '../api/bean/group/ConversationAuditUnReadResult';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { IConversationAuditObserver } from '../observer/IConversationAuditObserver';
import { IConversationAuditModel } from './IConversationAuditModel';
export declare class ConversationAuditModel extends IMSdkBaseObject implements IConversationAuditModel {
    private nextCursor;
    constructor(context: IMSdkContext);
    addObserver(observer: IConversationAuditObserver): void;
    removeObserver(observer: IConversationAuditObserver): void;
    /**
     * 获取最新审批列表
     */
    getNewestAuditList(limit: number, conversationShortId: bigint): Promise<IMResult<ConversationAuditListResult>>;
    /**
     * 加载审批列表
     * @returns
     */
    loadMoreAuditList(limit: number, conversationShortId: bigint): Promise<IMResult<ConversationAuditListResult>>;
    /**
     * 获取审批开关
     */
    getAuditSwitchStatus(conversationShortId: bigint, conversationType: number): Promise<IMResult<ConversationAuditSwitchResult>>;
    /**
     * 更新审批开关
     */
    updateAuditSwitchStatus(conversationShortId: bigint, conversationType: number, openAudit: boolean, ext?: Map<string, string>): Promise<IMResult<boolean>>;
    /**
     * 进群申请
     */
    sendConversationApply(conversationShortId: bigint, conversationType: number, map?: Map<string, string>): Promise<IMResult<boolean>>;
    /**
     * 进群审批
     */
    ackConversationApply(applyId: bigint, status: boolean, map?: Map<string, string>): Promise<IMResult<ConversationApplyAckResult>>;
    /**
     * 获取未读审批
     */
    getConversationAuditUnread(withUserPromptInfo: boolean): Promise<IMResult<ConversationAuditUnReadResult>>;
    /**
     * 批量获取未读审批
     */
    batchGetConversationAuditUnread(withUserPromptInfo: boolean, conversationIdList: bigint[]): Promise<IMResult<ConversationAuditUnReadResult>>;
    /**
     * 标记审批已读
     */
    markReadAllAudit(conversationShortId: bigint): Promise<boolean>;
}

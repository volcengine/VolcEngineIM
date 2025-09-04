import { Member } from './Member';
/** 会话 CoreInfo 结构 */
export declare class ConversationSubInfo {
    /**
     * 业务会话id
     */
    conversationId: string;
    /**
     * 父会话的id
     */
    parentConversationId: string;
    /**
     * 服务端id
     */
    shortId: bigint;
    /**
     * 父会话的shortId
     */
    parentConversationShortId: bigint;
    /**
     * 子会话状态
     */
    status: number;
    /**
     * 会话阶段（业务自定义）
     */
    bizStatus: string;
    /**
     * 创建时间
     */
    createTime: string;
    /**
     * 编辑时间
     */
    modifyTime: string;
    /**
     * 额外信息
     */
    extra: Map<string, string>;
    /**
     * 会话信箱
     */
    inbox: number;
    /**
     * 版本号
     */
    version: number;
    /**
     * 成员信息
     */
    memberList: Nullable<Member[]>;
}

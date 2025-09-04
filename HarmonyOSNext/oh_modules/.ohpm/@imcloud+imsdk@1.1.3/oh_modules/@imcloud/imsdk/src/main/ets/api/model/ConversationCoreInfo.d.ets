import { im_proto } from '../proto';
import { Conversation } from './Conversation';
import { ValuesBucket as ValuesBucket } from "@ohos.data.ValuesBucket";
import { TaskResultSet } from '../../storage/rdb/thread/TaskResultSet';
/** 会话 CoreInfo 结构 */
export declare class ConversationCoreInfo {
    /**
     * 会话 id
     * {@link Conversation.id}
     */
    conversationId: string;
    /**
     * Core Info 的版本号
     */
    version: bigint;
    /**
     * 会话名称
     */
    name: string;
    /**
     * 会话描述
     */
    desc: string;
    /**
     * 会话图标 / 群头像
     */
    icon: string;
    /**
     * 群公告
     */
    notice: string;
    /**
     * 群主 / 创建者
     */
    owner: string;
    /**
     * 加密 uid 群主
     */
    secOwner: string;
    /**
     * inboxType
     */
    inboxType: number;
    /**
     * 是否全部禁言（老版本全部禁言，只能禁言普通成员）
     */
    silent: number;
    /**
     * 部禁言的状态扩充（新版本上、可禁言全部人）
     */
    silentSource: number;
    /**
     * 禁言截止绝对时间，经过了校准，为server绝对时间
     */
    silentUntilTime: number;
    /**
     * silentNormalOnly
     */
    silentNormalOnly: number;
    /**
     * ext
     */
    ext: Map<string, string>;
    /**
     * mode以2个bit位的形式记录陌生人信息, 两个bit位分别对应ConversationId中的前后两个uid。
     * 如: conversationId="0:1:666:9095", mode=2(即0b10), 代表会话对于第一个uid(666)来说是陌生人会话
     */
    mode: number;
    /**
     * creatorUid
     */
    creatorUid: bigint;
    /**
     * 群聊创建时间
     */
    createTime: number;
    /**
     * 所属会话
     */
    parent?: Conversation;
    get extStr(): string;
    set extStr(str: string);
    static toValuesBucket(thisObj: ConversationCoreInfo): ValuesBucket;
    static buildFromDB(resultSet: TaskResultSet): Nullable<ConversationCoreInfo>;
    static buildFromRemote(parent: Conversation, info?: im_proto.IConversationCoreInfo): ConversationCoreInfo;
    static updateCoreInfoVersion(coreInfo: ConversationCoreInfo, newVersion: bigint): void;
}

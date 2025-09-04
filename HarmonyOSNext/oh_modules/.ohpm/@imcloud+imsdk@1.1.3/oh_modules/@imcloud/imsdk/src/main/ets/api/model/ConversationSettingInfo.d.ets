import { Conversation } from './Conversation';
import { FavoriteState, MuteState, StickTopState } from '../const/consts';
import { im_proto } from '../proto';
import { ValuesBucket as ValuesBucket } from "@ohos.data.ValuesBucket";
import { TaskResultSet } from '../../storage/rdb/thread/TaskResultSet';
/** 会话 Setting Info 结构 */
export declare class ConversationSettingInfo {
    /**
     * 会话 id
     * {@link Conversation.id}
     */
    conversationId: string;
    /**
     * 会话 Setting 版本
     */
    version: bigint;
    /**
     * 置顶状态
     * {@link Conversation.isStickOnTop}
     */
    stickTop: StickTopState;
    /**
     * setTopTime
     */
    setTopTime: number;
    /**
     * 免打扰状态
     * {@link Conversation.isMuted}
     */
    mute: MuteState;
    /**
     * 收藏状态
     * {@link Conversation.isFavorite}
     */
    favor: FavoriteState;
    /**
     * setFavoriteTime
     */
    setFavoriteTime: number;
    /**
     * ext
     */
    ext: Map<string, string>;
    /**
     * minIndex
     */
    minIndex: bigint;
    /**
     * readIndex
     */
    readIndex: bigint;
    /**
     * readIndexV2
     */
    readIndexV2: bigint;
    /**
     * 所属会话
     */
    parent?: Conversation;
    /** @internal 总的未读数 */
    private _readBadgeCount;
    get readBadgeCount(): number;
    set readBadgeCount(val: number);
    get extStr(): string;
    set extStr(str: string);
    /** @internal 分类型的未读数（例如免打扰时，对应的值为需要提醒的消息未读数） */
    private muteReadBadgeCountInfos;
    private mergeMuteReadBadgeCountInfos;
    static toValuesBucket(thisObj: ConversationSettingInfo): ValuesBucket;
    static buildFromDB(resultSet: TaskResultSet): ConversationSettingInfo | undefined;
    static buildFromRemote(parent: Conversation, info?: im_proto.IConversationSettingInfo): ConversationSettingInfo;
}

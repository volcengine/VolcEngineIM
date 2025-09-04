import Long from 'long';
import { im_proto } from '../proto';
export declare class Member {
    /**
     *  用户id
     */
    uid: bigint;
    /**
     * sortOrder
     */
    sortOrder?: bigint;
    /**
     * 成员角色 0: 普通成员 1: 群主  2: 管理员 3：访客
     */
    role: number;
    /**
     * 群成员在群里的昵称
     */
    alias: string;
    /**
     * 群ID，群聊时等于消息体中的conversationShortId
     */
    conversationId: string;
    /**
     * 加密uid
     */
    secUid: string;
    /**
     * conversationType
     */
    conversationType: im_proto.ConversationType;
    /**
     * 是否被禁言
     */
    silent: number;
    /**
     * 禁言截止绝对时间，经过了校准，为server绝对时间
     */
    silentUtilTime: number;
    /**
     * localCreateDataTime
     */
    localCreateDataTime: number;
    /**
     * 被当前用户@的时间戳
     */
    mentionTime: number;
    /**
     * 被禁言的话还有多长时间解封
     */
    leftSilentTime?: number;
    avatarUrl: string;
    markTypes: string[];
    /**
     * ext
     */
    ext: Map<string, string>;
    /**
     * 飞鸽中用户的角色
     */
    bizRole: string;
    /**
     *
     */
    groupSymbol: string;
    onlineStatus: number;
    /**
     * 是否被服务端禁言
     * @returns
     */
    get isServerBlocked(): boolean;
    static fromParticipant(p: im_proto.IParticipant, convId: string, convType?: im_proto.ConversationType): Member;
    /**
     * 对标Android的ConvertUtil#convert
     * @param ps
     * @param convId
     * @param previousMemberMap
     * @returns 根据服务端下发的成员数据结构转换为memberList
     */
    static convertParticipants(ps: im_proto.IParticipant[], convId: string, previousMemberMap?: Map<Long, Member>): Member[];
    /**
     * 对标Android的ConvertUtil#convert
     * @param ps
     * @param convId
     * @param secUidMap
     * @returns 根据成员uidList转换为memberList
     */
    static convertParticipantsByUid(uidList: bigint[], convId: string, sortOrder: bigint, secUidMap: Nullable<Map<bigint, string>>): Nullable<Member[]>;
    /**
     * 成员数据信息是否相等
     * @param member
     * @returns
     */
    static isAbsolutelyEqual(thisObj: Member, member: Member): boolean;
    /**
     * 针对Member中的bigint、long、map、object等类型，进行特殊处理
     * @param key
     * @param value
     * @returns
     */
    static replacer(key: ESObject, value: ESObject): ESObject;
    static reviver(key: ESObject, value: ESObject): ESObject;
    /**
     * 可序列化的 json str
     * @see fromJson
     * @returns
     */
    static toJson(member: Member): string;
    /**
     * @see toJson
     * @param jsonStr
     * @returns
     */
    static fromJson(jsonStr: string): Member;
}

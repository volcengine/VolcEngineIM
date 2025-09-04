import { IMResult } from '../../api/bean/IMHandlerResult';
import { ConversationChangeReason } from '../../api/const/consts';
import { Conversation } from '../../api/model/Conversation';
import { Member } from '../../api/model/Member';
import { SilentMemberInfo } from '../../api/model/SilentMemberInfo';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IConversationOperator } from './IConversationOperator';
import LightWeightMap from '@ohos.util.LightWeightMap';
import { IConversationObserver } from '../../observer/IConversationObserver';
/**
 * 会话操作：更新群名称、添加查询群成员等等
 */
export declare class ConversationOperator extends IMSdkBaseObject implements IConversationOperator {
    constructor(context: IMSdkContext);
    register(observer: IConversationObserver): void;
    unregister(observer: IConversationObserver): void;
    /**
     * 标记会话已读
     * @returns 返回当前的会话数据结构
     */
    markConversationRead(conId: string): Promise<Nullable<Conversation>>;
    /**
     * 查询会话的管理员信息
     * @returns 返回会话管理员member数组数据结构
     */
    queryGroupManagerList(conId: string): Promise<Nullable<Member[]>>;
    /**
     * 查询会话的所有成员信息
     * @returns 返回会话所有成员member数组数据结构
     */
    queryMemberList(conId: string): Promise<Nullable<Member[]>>;
    /**
     * 查询指定uid的群成员
     * @param uid 用户id
     * @returns 返回用户id对应的member数据结构
     */
    queryMember(conId: string, uid: string): Promise<Nullable<Member>>;
    /**
     * 将toAddUserIdList拉进会话群聊
     * @param convShortId 会话shortId，目前抖音群聊convShortId与convId相等
     * @param toAddMembersUidList 期望加入群聊的用户uid
     * @param bizExtMap 配置信息Map结构
     * @param convType 会话的Type，默认是 @see im_proto.ConversationType.GROUP_CHAT
     * @param inboxType 默认是 @see InBoxType.DEFAULT
     * @returns 加入群聊的member数据结构list
     */
    addMember(conId: string, convShortId: bigint, toAddMembersUidList: string[], bizExtMap: Map<string, string>, convType?: number, inboxType?: number): Promise<IMResult<Member[]>>;
    /**
     * 将uidList群成员踢出群聊
     * @param uidList 待操作的群成员
     * @param bizExt 业务参数、目前抖音上层使用了LightWeightMap数据结构而不是Map
     * @returns 操作成功则返回uidList中已踢出群聊的member列表数据结构
     */
    removeMember(conId: string, uidList: string[], bizExt?: Map<string, string> | LightWeightMap<string, string>): Promise<IMResult<Member[]>>;
    /***
     * 更新群成员
     * @param member 待更新的成员数据结构
     * @returns 操作成功返回true
     */
    updateMember(conId: string, member: Member): Promise<Nullable<boolean>>;
    /***
     * 更新群公告
     * @param notice 传空字符串意味着清除群公告
     * @returns 操作成功则返回对应会话的数据结构
     */
    updateNotice(conId: string, notice: string): Promise<IMResult<Conversation>>;
    /***
     * 设置会话名称
     * @param name 传空字符串意味着清除名称设置
     * @returns 操作成功则返回对应会话的数据结构
     */
    updateName(conId: string, name: string): Promise<IMResult<Conversation>>;
    /***
     * 设置会话头像
     * @param name 传空字符串意味着清除头像设置
     * @returns 操作成功则返回对应会话的数据结构
     */
    updateIcon(conId: string, icon: string): Promise<IMResult<Conversation>>;
    /***
     * 设置会话描述
     * @param name 传空字符串意味着清除描述设置
     * @returns 操作成功则返回对应会话的数据结构
     */
    updateDesc(conId: string, desc: string): Promise<IMResult<Conversation>>;
    /**
     * 设置会话置顶状态：置顶或取消置顶
     * @param top 为true则设置会话置顶；否则取消置顶
     * @returns 操作成功则返回对应会话的数据结构
     */
    stickTop(conId: string, top: boolean): Promise<IMResult<Conversation>>;
    /**
     * 设置会话静音/免打扰状态：开启免打扰或取消免打扰
     * @param mute 为true则设置会话处于免打扰模式；否则取消免打扰
     * @returns 操作成功则返回对应会话的数据结构
     */
    mute(conId: string, mute: boolean): Promise<IMResult<Conversation>>;
    /**
     * 更新会话全局配置的附加信息，只处理特定的key-value
     * 如果希望全量更新会话全局配置则使用extMap👇
     * @see upsertCoreExtMap
     * @param key
     * @param value
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertCoreExtKv(conId: string, key: string, value: string): Promise<Nullable<Conversation>>;
    /**
     * 更新会话全局配置的附加信息，注意会全量覆盖更新
     * 轻量的数据更新建议仅更新对应的 key-value👇
     * @see upsertCoreExtKv
     * @param ext  附加信息字段，注意会全量覆盖更新。如果需要清除原来的赋值，ext的value传空字符串即可
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertCoreExtMap(conId: string, ext: Map<string, string>): Promise<Nullable<Conversation>>;
    /**
     * 轻量更新会话个人维度的配置附加信息，只更新特定的key-value
     * @param key
     * @param value
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertSettingExtKv(conId: string, key: string, value: string): Promise<Nullable<Conversation>>;
    /**
     * 全量更新会话个人维度的全部配置附加信息
     * 轻量的数据更新建议使用 upsertSettingKv
     * @param convId
     * @param ext 新的配置信息，server会直接使用其作为会话的最新配置信息
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertSettingExtMap(conId: string, ext: Map<string, string>): Promise<Nullable<Conversation>>;
    /**
     * 设置群成员的权限
     * @param uid 用户id
     * @param role 权限等级传0时，意味着清除权限设置、即设置为普通成员
     * @param bizExtMap 业务参数信息
     * @returns 如果更新成功，会返回uid对应的成员member数据结构；否则返回undefined
     */
    setMemberRole(conId: string, uid: string, role: im_proto.GroupRole, bizExtMap?: Nullable<Map<string, string>>): Promise<IMResult<Member>>;
    /**
     * 修改会话成员在该会话中的昵称
     * @param uid 用户id
     * @param alias 用户昵称 传空字符串时，意味着清除昵称设置
     * @param bizExtMap
     * @returns
     */
    changeMemberAlias(conId: string, uid: string, alias: string, bizExtMap?: Nullable<Map<string, string>>): Promise<IMResult<Member>>;
    /**
     * 批量设置群成员禁言
     * @param silentMemberInfo 待禁言群成员
     * @param bizExtMap 业务附加参数信息
     * @returns 参数异常返回undefined；操作成功则返回空的bigint列表；操作失败则返回失败的用户uid列表
     */
    setMemberSilent(conId: string, silentMemberInfo: SilentMemberInfo[], bizExtMap?: Map<string, string>): Promise<IMResult<bigint[]>>;
    /**
     * 批量解除群成员禁言
     * @param silentMemberInfo 待解除禁言的群成员
     * @param bizExtMap 业务附加参数信息
     * @returns 参数异常返回undefined；操作成功则返回空的bigint列表；操作失败则返回失败的用户uid列表
     */
    setMemberUnSilent(conId: string, silentMemberInfo: SilentMemberInfo[], bizExtMap?: Map<string, string>): Promise<IMResult<bigint[]>>;
    /**
     * 传入uidList、将该群成员列表解除禁言
     * @param uidList 待解除禁言的群成员列表
     * @param bizExtMap 业务附加参数信息
     * @returns 参数异常返回undefined；操作成功则返回空的bigint列表；操作失败则返回失败的用户uid列表
     */
    setMemberUnSilentByUid(conId: string, uidList: string[], bizExtMap?: Map<string, string>): Promise<IMResult<bigint[]>>;
    /**
     * 设置会话禁言状态
     * @param isSilent true 会话禁言；false 解除禁言
     * @returns 返回true代表操作成功；undefined为参数异常、请求未发出；false代表接口操作失败
     */
    setConversationSilent(conId: string, isSilent: boolean, silentNormalOnly: boolean): Promise<IMResult<boolean>>;
    /**
     * 解除会话/群聊
     * @param deleteLocal true 标记删除；false 解除会话
     * @param needPullConv true 如果本地没有会话则会拉取群聊会话信息
     * @returns 返回true代表操作成功；undefined为参数异常、请求未发出；false代表接口操作失败
     */
    dissolve(conId: string, deleteLocal: boolean, needPullConv: boolean): Promise<IMResult<string>>;
    /**
     * 退出群聊
     * @param isReqDelete 是否请求接口执行删除会话请求
     * @returns 返回true代表操作成功；undefined为参数异常、请求未发出；false代表接口操作失败
     */
    leave(conId: string, isReqDelete?: boolean): Promise<IMResult<boolean>>;
    /**
     * 获取群管理信息
     */
    getGroupManagementInfo(conID: string, typeList: number[], useLocalCache: boolean): Promise<IMResult<im_proto.IGetGroupManagerInfoResponseBody>>;
    /**
     * 批量设置群成员的权限
     * @param convId
     * @param toUpdateUidList
     * @param role
     * @param map
     * @returns 修改成功后返回所有更新成功的成员Member结构；否则返回undefined
     */
    batchChangeMemberRole(conId: string, toUpdateUidList: string[], role: im_proto.GroupRole, map?: Nullable<Map<string, string>>): Promise<Nullable<Member[]>>;
    /**
     * 在会话localKVMap中加入业务需要的字段，仅客户端本地使用、不会发网络请求
     * @param key
     * @param value
     * @returns 操作成功则返回对应会话的数据结构
     */
    addLocalKV(conId: string, key: string, value: string): Promise<Nullable<Conversation>>;
    /**
     * 保存草稿
     * @param draftContent
     * @returns 操作成功则返回对应会话的数据结构; 否则返回undefined
     */
    saveDraft(conId: string, draftContent: string): Promise<Nullable<Conversation>>;
    /**
     * 更新本地数据库的会话的localExt, 仅更新指定的key-value
     * @param key
     * @param value
     * @returns 操作成功则返回对应会话的数据结构; 否则返回undefined
     */
    updateLocalExtKv(conId: string, key: string, value: string): Promise<Nullable<Conversation>>;
    /**
     * 更新本地数据库的会话的localExt, 全量更新
     * @param localExt
     * @returns 操作成功则返回对应会话的数据结构; 否则返回undefined
     */
    updateLocalExtMap(conId: string, localExt: Map<string, string>): Promise<Nullable<Conversation>>;
    /**
     * 更新本地数据库的会话的setting ext
     * @returns 操作成功则返回对应会话的数据结构; 否则返回undefined
     */
    updateLocalSettingExt(conId: string): Promise<Nullable<Conversation>>;
    /**
     * 更新本地数据库的会话全局配置信息 core ext
     * @returns 操作成功则返回对应会话的数据结构; 否则返回undefined
     */
    updateLocalCoreInfoExt(conId: string): Promise<Nullable<Conversation>>;
    /**
     * 更新会话排序依据的时间戳
     * @param orderTimestamp
     * @returns true 标识成功
     */
    updateOrderTimestamp(conId: string, orderTimestamp: number): Promise<Nullable<boolean>>;
    /**
     * 更新会话判断未读数降级的时间戳
     * @param unreadDemoteTime
     * @returns true 标识成功
     */
    updateUnreadDemoteTime(conId: string, unreadDemoteTime: number): Promise<Nullable<boolean>>;
    /**
     * 对齐Android的方法
     * @param conversation
     */
    updateConversation(conversation: Nullable<Conversation>, updateChangeReason?: ConversationChangeReason): Promise<void>;
    /**
     * 更新群聊设置信息
     * @param params
     * @returns
     */
    updateGroup(conID: string, type: number, value: Nullable<string>): Promise<IMResult<boolean>>;
    /**
     * 根据会话ID查询会话数据：内存 -> 数据库 -> 网络
     * @param conversationId 查询的会话id
     * @return 查询得到的会话
     */
    getConversationByCid(conversationId: string, memoryFirst?: boolean): Promise<Conversation>;
}

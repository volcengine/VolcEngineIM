import { IMSdkClient } from '../../client/IMSdkClient';
import { Context as Context } from "@ohos.abilityAccessCtrl";
import { IMDeviceInfo, IMEnvService, IMLogService, IMNetService, IMWSService } from '@imcloud/imsdk_common';
import { IMAccessor } from '@imcloud/imsdk_common/src/main/ets/api/IMAccessor';
import { BIMServiceManager } from '../service/BIMServiceManager';
import { BIMConversationListResult } from './model/BIMConversationListResult';
import { BIMResult } from './model/BIMResult';
import { BIMSDKConfig } from './model/BIMSDKConfig';
import { BIMGetMessageOption } from './model/BIMGetMessageOption';
import { BIMMessageListResult } from './model/BIMMessageListResult';
import { BIMMessage } from './model/BIMMessage';
import { BIMSendCallback } from './interface/BIMSendCallback';
import { BIMConversation } from './model/BIMConversation';
import { BIMMessageListener } from './interface/BIMMessageListener';
import { BIMConversationListListener } from './interface/BIMConversationListListener';
import { BIMUnReadInfo } from './model/BIMUnReadInfo';
import { BIMGroupInfo } from './model/BIMGroupInfo';
import { BIMConnectListener } from './interface/BIMConnectListener';
import { BIMMember } from './model/BIMMember';
import { BIMINService } from '../service/BIMINService';
import { BIMMessageNewPropertyModify } from './model/BIMMessageNewPropertyModify';
import { BIMMemberRole } from './enum/BIMMemberRole';
import { AppLifeObserver } from '../uitls/AppLifeObserver';
import { BIMReporterManager } from '../report/BIMReporterManager';
import { RepairManager } from '../../handler/repair/RepairManager';
import { BIMSyncServerListener } from './interface/BIMSyncServerListener';
import { BIMSearchMsgInfo } from './model/BIMSearchMsgInfo';
import { BIMLiveExpandService } from '../../live/api/interface/BIMLiveExpandService';
import { BIMMessageService } from '../service/BIMMessageService';
/**
 * @detail api
 * @brief IM SDK 对外接口类，通过此类提供所有 IM SDK 能力接口。
 * @list overview
 */
export declare class BIMClient {
    /** @hidden */
    private _tag;
    /** @hidden */
    private _appId;
    /** @hidden */
    innerClient: IMSdkClient | undefined;
    /** @hidden */
    private _imDepend;
    /** @hidden */
    private _config;
    /** @hidden */
    private _context;
    /** @hidden */
    _imAccessor: IMAccessor;
    /** @hidden */
    private _curUid;
    /** @hidden */
    readonly serviceManager: BIMServiceManager;
    /** @hidden */
    readonly connectListenerList: BIMConnectListener[];
    /** @hidden */
    readonly convListenerList: BIMConversationListListener[];
    /** @hidden */
    readonly messageListenerList: BIMMessageListener[];
    /** @hidden */
    readonly appLife: AppLifeObserver;
    /** @hidden */
    reportManager: BIMReporterManager | undefined;
    /** @hidden */
    repairManager: RepairManager | undefined;
    /** @hidden */
    isForeground: boolean;
    /**
     * @hidden
     * @param app    应用 Application 实例。
     * @param appId  从[控制台](https://console.volcengine.com/rtc/im/appManage)获取的应用 ID。
     *               不同应用 ID 无法进行互通。
     * @param config 配置信息，参看 BIMSDKConfig{@link #BIMSDKConfig}。
     * @return <br>
     * + `true`: 成功。
     * + `false`: 失败。
     * @detail api
     * @brief 初始化 SDK。
     */
    constructor(context: Context, appID: number, config?: BIMSDKConfig, env?: number, lane?: string);
    /**
     * @detail api
     * @brief 初始化 SDK。
     * @group initlogin
     * @order 0
     */
    initSDK(): Promise<void>;
    /**
     * @hidden
     */
    private initDeviceListener;
    /**
     * @detail api
     * @brief 注销 SDK, 释放内存缓存资源、注销监听等。
     * @group initlogin
     * @order 1
     */
    unInitSDK(): boolean;
    /**
     * @param listener 同步服务端会话、消息数据监听，参看 BIMSyncServerListener{@link #BIMSyncServerListener}。
     * @detail api
     * @brief 设置同步服务端会话、消息数据监听。
     * @note 需要在init后，login前注册监听
     */
    addSyncServerListener(listener: BIMSyncServerListener): boolean;
    /**
     * @param listener 同步服务端会话、消息数据监听，参看 BIMSyncServerListener{@link #BIMSyncServerListener}。
     * @detail api
     * @brief 移除同步服务端会话、消息数据监听。
     */
    removeSyncServerListener(listener: BIMSyncServerListener): boolean;
    /**
     * @param uid      用户 ID。
     * @param token    用户 Token。
     * @param callback 登录结果回调，参看 BIMSimpleCallback{@link #BIMSimpleCallback}。
     * @detail api
     * @brief 登录服务器。
     * @group initlogin
     * @order 2
     */
    login(uidStr: string, token: string): Promise<boolean>;
    /** @hidden */
    loginInner(uidStr: string, token: string, imDeviceInfo: IMDeviceInfo): Promise<boolean>;
    /** @hidden */
    private loginToB;
    private KEY_PREFIX;
    private checkToken;
    /**
     * @hidden
     */
    private loginInCompany;
    /**
     * 云控配置
     */
    private initConfig;
    /**
     * @detail api
     * @brief 登出服务器。
     * @group initlogin
     * @order 3
     */
    logout(): void;
    /**
     * @param listener 长链状态监听方，参看 BIMConnectListener{@link #BIMConnectListener}。
     * @detail api
     * @brief 设置长链状态监听。
     * @group initlogin
     * @order 4
     */
    addConnectListener(listener: BIMConnectListener): boolean;
    /**
     * @param listener 长链状态监听方，参看 BIMConnectListener{@link #BIMConnectListener}。
     * @detail api
     * @brief 移除长链状态监听。
     * @group initlogin
     * @order 5
     */
    removeConnectListener(listener: BIMConnectListener): boolean;
    /**
     * @param cursor   分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextCursor。
     * @param count    分页拉取的个数。一次分页拉取不宜太多，否则可能影响拉取的速度，建议每次拉取 100 个会话。
     * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMConversationListResult{@link #BIMConversationListResult}。
     * @detail api
     * @brief 获取会话列表。
     * @notes <br>
     * + 历史会话数量可能很多，因此建议采用分页查询的方式进行接口调用。
     * + 该接口拉取的是本地缓存的会话。若服务器会话有更新，SDK 内部会自动同步，并通过 BIMResultCallback{@link #BIMResultCallback} 回调告知用户。
     * + 如果会话全部拉取完毕，结果回调 BIMResultCallback{@link #BIMResultCallback} 中的 hasMore 获取字段值为 false。
     * @group groupSession
     * @order 0
     */
    getConversationList(cursor: number, count: number): Promise<BIMResult<BIMConversationListResult>>;
    /**
     * @param conversationId 会话 ID。
     * @param option         获取消息选项，参看 BIMGetMessageOption{@link #BIMGetMessageOption}。
     * @param callback       结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMessageListResult{@link #BIMMessageListResult}。
     * @detail api
     * @brief 获取历史消息（锚点之前的消息），返回消息顺序从新到旧。
     * @group messageSendReceive
     * @order 0
     */
    getHistoryMessageList(conversationId: string, option: BIMGetMessageOption): Promise<BIMResult<BIMMessageListResult>>;
    /**
     * @param listener 消息监听方，参看 BIMMessageListener{@link #BIMMessageListener}。
     * @detail api
     * @brief 设置消息监听。
     * @group messageSendReceive
     * @order 1
     */
    addMessageListener(listener: BIMMessageListener): boolean;
    /**
     * @param listener 消息监听方，参看 BIMMessageListener{@link #BIMMessageListener}。
     * @detail api
     * @brief 移除消息监听。
     * @group messageSendReceive
     * @order 2
     */
    removeMessageListener(listener: BIMMessageListener): boolean;
    /**
     * @param listener 会话监听方，参看 BIMConversationListListener{@link #BIMConversationListListener}。
     * @detail api
     * @brief 添加会话监听。
     * @group groupSession
     * @order 1
     */
    addConversationListener(listener: BIMConversationListListener): boolean;
    /**
     * @param listener 会话监听方，参看 BIMConversationListListener{@link #BIMConversationListListener}。
     * @detail api
     * @brief 移除会话监听。
     * @group groupSession
     * @order 2
     */
    removeConversationListener(listener: BIMConversationListListener): boolean;
    /**
     * @param conversationId 会话 ID。
     * @param callback       结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMConversation{@link #BIMConversation}。
     * @detail api
     * @brief 获取指定单个会话。
     * @group groupSession
     * @order 3
     */
    getConversation(conversationId: string): Promise<BIMResult<Nullable<BIMConversation>>>;
    /**
     * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMUnReadInfo{@link #BIMUnReadInfo}。
     * @detail api
     * @brief 获取所有会话的未读消息总数。
     * @notes 会话未读消息不包括设置为免打扰会话中的未读消息。
     * @group groupSession
     * @order 4
     */
    getTotalUnreadMessageCount(): Promise<BIMUnReadInfo>;
    /**
     * @param message        消息体，由 `createXxxMessage` 接口创建，参看 BIMMessage{@link #BIMMessage}。
     * @param conversationId 会话 ID。
     * @param callback       发送结果回调，参看 BIMSendCallback{@link #BIMSendCallback}。
     * @detail api
     * @brief 发送消息。
     * @group messageSendReceive
     * @order 3
     */
    sendMessage(message: BIMMessage, conversationId: string, sendCallback?: BIMSendCallback): Promise<void>;
    /**
     * @param conversationId 会话 ID。
     * @detail api
     * @brief 标记会话已读。
     * @group groupSession
     * @order 5
     */
    markConversationRead(conversationId: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param ids 待添加的群成员 ID 列表。
     * @detail api
     * @brief 添加群成员。
     * @group groupSession
     * @order 6
     */
    addGroupMemberList(conversationId: string, ids: string[]): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param 待移除的群成员 ID 列表。
     * @detail api
     * @brief 移除群成员。
     * @group groupSession
     * @order 7
     */
    removeGroupMemberList(conversationId: string, ids: string[]): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param uidList 需要更改身份的群成员列表。
     * @param role 群组角色，参看 BIMMemberRole{@link #BIMMemberRole}。
     * @detail api
     * @brief 设置群成员角色。
     * @group groupSession
     * @order 8
     */
    setGroupMemberRole(conversationId: string, uidList: string[], role: BIMMemberRole): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param isDeleteLocal 是否在本地删除。
     * @detail api
     * @brief 解散群组。
     * @group groupSession
     * @order 9
     */
    dissolveGroup(conversationId: string, isDeleteLocal: boolean): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param isDeleteServer 是否在服务器删除。
     * @detail api
     * @brief 离开群组。
     * @group groupSession
     * @order 10
     */
    leaveGroup(conversationId: string, isDeleteServer: boolean): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param name 群组名称。
     * @detail api
     * @brief 设置群组名称。
     * @group groupSession
     * @order 11
     */
    setGroupName(conversationId: string, name: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param notice 群公告内容。
     * @detail api
     * @brief 设置群公告。
     * @group groupSession
     * @order 12
     */
    setGroupNotice(conversationId: string, notice: string): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param ext          会话本地额外信息。
     * @detail api
     * @brief 设置会话本地额外信息。
     * @group groupSession
     * @order 13
     */
    setConversationLocalExt(conversationId: string, ext: Map<string, string>): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param ext          会话本地额外信息。
     * @detail api
     * @brief 设置会话私有额外信息。
     * @group groupSession
     * @order 14
     */
    setConversationMyExt(conversationId: string, ext: Map<string, string>): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param ext          会话本地额外信息。
     * @detail api
     * @brief 设置会话额外信息。
     * @group groupSession
     * @order 15
     */
    setConversationCoreExt(conversationId: string, ext: Map<string, string>): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param isStickTop 是否置顶。
     * @detail api
     * @brief 置顶会话。
     * @group groupSession
     * @order 16
     */
    stickTopConversation(conversationId: string, isStickTop: boolean): Promise<BIMResult<boolean>>;
    /**
     * @param conversationId 会话 ID。
     * @param isMute 是否设置为免打扰。
     * @detail api
     * @brief 设置会话免打扰。
     * @group groupSession
     * @order 17
     */
    muteConversation(conversationId: string, isMute: boolean): Promise<BIMResult<boolean>>;
    /**
     * @param toUid    对方用户 ID。
     * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMConversation{@link #BIMConversation}。
     * @detail api
     * @brief 创建单聊会话。
     * @group groupSession
     * @order 18
     */
    createSingleConversation(toUid: string): Promise<BIMResult<BIMConversation | undefined>>;
    /**
     * @param uidList  用户 ID 列表。
     * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMConversation{@link #BIMConversation}。
     * @detail api
     * @brief 创建群聊。
     * @group groupSession
     * @order 19
     */
    createGroupConversation(uidList: string[]): Promise<BIMResult<BIMConversation | undefined>>;
    /**
     * @hidden
     */
    createGroupConversationWithInfo(groupInfo: BIMGroupInfo, uidList: string[]): Promise<BIMResult<BIMConversation | undefined>>;
    /**
     * @param conversationId 会话 ID。
     * @param callback       群成员列表回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMember{@link #BIMMember}。
     * @detail api
     * @brief 获取群成员。
     * @group groupSession
     * @order 20
     */
    getConversationMemberList(conversationId: string): Promise<BIMResult<BIMMember[]>>;
    /**
     * @param draft          草稿内容。
     * @param conversationId 会话 ID。
     * @detail api
     * @brief 设置会话草稿。
     * @group groupSession
     * @order 21
     */
    setConversationDraft(draft: string, conversationId: string): Promise<void>;
    /**
     * @param conversationId 会话 ID。
     * @param callback       结果回调，参看 BIMSimpleCallback{@link #BIMSimpleCallback}。
     * @detail api
     * @brief 通过会话 ID 删除会话。
     * @notes 调用本接口后，SDK 会从本地和服务端删除该会话及会话中的历史消息，且不可恢复。
     * @group groupSession
     * @order 22
     */
    deleteConversation(conversationId: string): Promise<BIMResult<boolean>>;
    /**
     * @param bimMessage 待删除的消息，参看 BIMMessage{@link #BIMMessage}。
     * @param callback   结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 删除本地和服务端消息。
     * @group messageSendReceive
     * @order 4
     */
    deleteMessage(bimMessage: BIMMessage): Promise<BIMResult<boolean>>;
    /**
     * @param message  待撤回的消息，参看 BIMMessage{@link #BIMMessage}。
     * @param callback 结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 撤回消息。
     * @group messageSendReceive
     * @order 5
     */
    recallMessage(message: BIMMessage): Promise<BIMResult<boolean>>;
    /**
     * @param message  待更新的消息
     * @param callback 结果回调, 参看 BIMResultCallback{@link #BIMResultCallback},BIMMessage{@link #BIMMessage}
     * @detail api
     * @brief 修改消息内容和ext。
     * @group groupSession
     * @order 23
     */
    modifyMessage(message: BIMMessage): Promise<BIMResult<Nullable<BIMMessage>>>;
    /**
     * @param message       待修改属性的消息，参看 BIMMessage{@link #BIMMessage}。
     * @param propertyItems 更新的消息属性，参看 BIMMessageNewPropertyModify{@link #BIMMessageNewPropertyModify}。
     * @param callback      结果回调，参看 BIMSimpleCallback{@link #BIMSimpleCallback}。
     * @detail api
     * @brief 批量修改消息属性。
     * @group groupSession
     * @order 24
     */
    modifyMessageProperty(message: BIMMessage, propertyItems: BIMMessageNewPropertyModify[]): Promise<BIMResult<boolean>>;
    /**
     * @param message  待更新的消息，参看 BIMMessage{@link #BIMMessage}。
     * @param localExt 本地扩展信息。
     * @param completion 结果回调，其中 `error` 参看 BIMErrorCode{@link #BIMErrorCode}。
     * @detail api
     * @brief 修改消息本地扩展信息。
     */
    setMessageLocalExt(message: BIMMessage, localExt: Map<string, string>): Promise<BIMResult<Nullable<BIMMessage>>>;
    /**
     * @param text 消息文本。
     * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 创建文本消息。
     * @group messageSendReceive
     * @order 6
     */
    createTextMessage(text: string): BIMMessage | undefined;
    /**
     * @param uri 图片路径。
     * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 创建图片消息。
     * @notes 若图片来自系统相册，需要先把图片导入 App 目录下。
     * @group messageSendReceive
     * @order 7
     */
    createImageMessage(uri: string): Promise<Nullable<BIMMessage>>;
    /**
     * @param bimMessage 消息体，参看 BIMMessage{@link #BIMMessage}。
     * @param callback   结果回调，参看 BIMResultCallback{@link #BIMResultCallback}, BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 刷新媒体信息，媒体 URL 过期时调用该方法。
     * @group groupSession
     * @order 25
     */
    refreshMediaMessage(bimMessage: BIMMessage): Promise<BIMResult<Nullable<BIMMessage>>>;
    /**
     * @param text       消息文本。
     * @param atUidList  需要 @ 的用户列表。
     * @param refMessage 引用的消息，参看 BIMMessage{@link #BIMMessage}。
     * @param hint       业务透传引用信息，无法动态编辑。
     * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 创建带引用消息的文本消息。
     * @group messageSendReceive
     * @order 8
     */
    createTextMessageFullInfo(text: string, atUidList?: string[], refMessage?: BIMMessage, hint?: string): BIMMessage | undefined;
    /**
     * @param uri 视频路径。
     * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 创建视频消息。
     * @notes 若视频来自系统相册，需要先把视频导入 App 目录下。
     * @group messageSendReceive
     * @order 9
     */
    createVideoMessage(uri: string): Promise<Nullable<BIMMessage>>;
    /**
     * @param uri      文件 URI。
     * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 创建文件消息。
     * @group messageSendReceive
     * @order 10
     */
    createFileMessage(uri: string): Promise<Nullable<BIMMessage>>;
    /**
     * @param uri  音频 URI。
     * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 创建语音消息。
     * @group messageSendReceive
     * @order 11
     */
    createAudioMessage(uri: string): Promise<Nullable<BIMMessage>>;
    /**
     * @param data 自定义参数。
     * @return 消息体，参看 BIMMessage{@link #BIMMessage}。
     * @detail api
     * @brief 创建自定义消息。
     * @group messageSendReceive
     * @order 12
     */
    createCustomMessage(data: string): Nullable<BIMMessage>;
    /**
     * @param conversationId 会话 ID，如果为空则全局搜索
     * @param key 关键词
     * @param completion 完成回调，参看 BIMSearchMsgInfo{@link #BIMSearchMsgInfo}。
     * @detail api
     * @brief 搜索本地消息。
     * @group messageSendReceive
     * @order 13
     */
    searchLocalMessage(conversationId: string, key: string): Promise<BIMResult<BIMSearchMsgInfo[]>>;
    /**
     * @return 用户 ID。
     * @detail api
     * @brief 获取当前用户 ID。
     * @group initlogin
     * @order 6
     */
    getCurrentUserID(): string;
    /**
     * @return 当前 appID
     * @detail api
     * @brief 获取当前 appID。
     * @group initlogin
     * @order 7
     */
    getAppID(): number;
    /**
     * @return SDK 版本号名称。
     * @detail api
     * @brief 获取 SDK 版本号名称。
     * @group initlogin
     * @order 8
     */
    getVersion(): string;
    /**
     * @return SDK 版本号。
     * @detail api
     * @brief 获取 SDK 版本号。
     * @group initlogin
     * @order 9
     */
    getVersionCode(): number;
    /**
     * @return 设备 did。
     * @detail api
     * @brief 获取设备 did。
     * @group initlogin
     * @order 10
     */
    getSDKDid(callBack: (did: string) => void): void;
    /**
     * @return 获取当前环境
     * @hidden
     */
    getEnv(): number;
    /**
     * @hidden
     */
    get logService(): IMLogService;
    /**
     * @hidden
     */
    get netService(): IMNetService;
    /**
     * @hidden
     * 内部特有的功能点
     * @returns
     */
    getINService(): BIMINService | undefined;
    /**
     * @return 直播群service。
     * @detail api
     * @brief 获取直播群service。
     */
    getLiveService(): BIMLiveExpandService | undefined;
    /** @hidden */
    getMessageService(): BIMMessageService | undefined;
    /**
     * @hidden
     */
    log(tag: string, content: string): void;
    /**
     * @hidden
     */
    static isTob(): boolean;
    /**
     * @hidden
     */
    registerNetService(net: IMNetService): void;
    /**
     * @hidden
     */
    registerLogService(log: IMLogService): void;
    /**
     * @hidden
     */
    registerEnvService(env: IMEnvService): void;
    /**
     * @hidden
     */
    registerWSService(ws: IMWSService): void;
    getWSService(): IMWSService;
    /**
     * @hidden
     */
    onAppForegroundChang(isForeground: boolean): void;
    /**
     * @hidden
     */
    private isUidValid;
    /** @hidden */
    isUseStringUid(): boolean;
    /** @hidden */
    getCurrentUserIDString(): string;
    /** @hidden */
    getUidStr(): string;
    /**
     * @return 服务端时间戳，单位为毫秒。
     * @detail api
     * @brief 获取服务端时间。
     */
    getServerTime(): number;
}

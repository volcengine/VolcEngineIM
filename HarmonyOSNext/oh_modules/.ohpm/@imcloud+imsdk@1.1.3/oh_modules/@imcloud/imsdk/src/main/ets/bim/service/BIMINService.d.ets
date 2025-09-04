import { IMAccessor, InnerService } from '@imcloud/imsdk_common';
import { BIMResult } from '../api/model/BIMResult';
import { BIMMessage } from '../api/model/BIMMessage';
import { BIMActionType } from '../api/enum/BIMActionType';
import { IMSdkClient } from '../../client/IMSdkClient';
import { BIMClient } from '../api/BIMClient';
import { BIMServiceManager } from './BIMServiceManager';
import { ParticipantIndexInfo } from '../../api/model/ParticipantIndexInfo';
import { BIMMarkMessageListLoadResult } from '../../handler/message/FetchMarkMessageHandler';
import { BIMMessageReadStatusModel } from '../api/model/BIMMessageReadStatusModel';
import { BIMSilentMemberInfo } from '../api/model/BIMSilentMemberInfo';
import { BIMConversation } from '../api/model/BIMConversation';
import { BIMUnReadInfo } from '../api/model/BIMUnReadInfo';
import { BIMUnreadMessageListener } from '../api/interface/BIMUnreadMessageListener';
/**
 * 内部业务功能，未对外提供
 */
export declare class BIMINService implements InnerService {
    private readonly tag;
    innerSdk: IMSdkClient;
    bimClient: BIMClient;
    serviceManager: BIMServiceManager;
    groupReadInfoCache: Map<string, Map<bigint, ParticipantIndexInfo>>;
    readonly bimUnreadMessageListenerList: BIMUnreadMessageListener[];
    constructor(innerSdk: IMSdkClient, bimClient: BIMClient);
    init(context: Context, imAccessor: IMAccessor): void;
    unInit(context: Context): void;
    onLogin(context: Context, uid: bigint): void;
    onLogout(): void;
    /**
     * 收藏、pin、消息
     *
     * @param message
     */
    markMessage(bimMessage: BIMMessage, actionType: BIMActionType, isMark: boolean, sortTime: number, tag: number): Promise<BIMResult<boolean>>;
    fetchMarkedMessage(cid: string, actionType: BIMActionType, tag: number, asc: boolean, cursor: bigint, limit: number, clearUnreadCount: boolean): Promise<BIMResult<BIMMarkMessageListLoadResult>>;
    /**
     * 标记所有会话是否已读
     *
     * @param markType 标记类型
     */
    markAllConversationRead(): Promise<BIMResult<boolean>>;
    log(tag: string, content: string): void;
    /**
     * 从服务端同步成员readIndex,需要业务进入回话后循环调用刷新
     * @param conversationId
     * @returns 返回<cid,<uid,readIndex>>
     */
    refreshConversationUidRead(conversationIdList: string[]): Promise<Map<string, Map<bigint, ParticipantIndexInfo>>>;
    /**
     * 停止刷新
     * @param conversationId
     */
    stopRefresh(conversationId: string): void;
    /**
     * 从本地获取已读、未读成员
     * @param conversationId
     */
    getMessageUidRead(conversationId: string, bimMessage: BIMMessage): Promise<BIMMessageReadStatusModel>;
    /**
     * 设置会话禁言状态
     * @param isSilent true 会话禁言；false 解除禁言
     * @param silentNormalOnly 只禁言普通成员，默认是所有人都被禁言
     * @returns 返回true代表操作成功；undefined为参数异常、请求未发出；false代表接口操作失败
     */
    setConversationSilent(conversationId: string, isSilent: boolean, silentNormalOnly: boolean): Promise<BIMResult<boolean>>;
    /**
     * 批量设置群成员禁言
     * @param convId 会话id
     * @param silentMemberInfo 待禁言群成员
     * @param bizExtMap 业务附加参数信息
     * @returns 参数异常返回undefined；操作成功则返回空的uid列表；操作失败则返回失败的用户uid列表
     */
    setMemberSilent(conversationId: string, silentMemberInfo: BIMSilentMemberInfo[], bizMap?: Map<string, string>): Promise<BIMResult<string[]>>;
    /**
     * 批量解除群成员禁言
     * @param silentMemberInfo 待解除禁言的群成员
     * @param bizMap 业务附加参数信息
     * @returns 参数异常返回undefined；操作成功则返回空的uid列表；操作失败则返回失败的用户uid列表
     */
    setMemberUnSilent(conversationId: string, silentMemberInfo: BIMSilentMemberInfo[], bizMap?: Map<string, string>): Promise<BIMResult<string[]>>;
    /**
     * 添加未读数监听
     *
     * @param listener
     */
    addTotalUnreadListener(listener: BIMUnreadMessageListener): void;
    /**
     * 移除未读数监听
     * @param listener
     */
    removeTotalUnreadListener(listener: BIMUnreadMessageListener): void;
    /**
     * 调用更新未读数
     * @param changedConversation
     * @param bimUnReadInfo
     */
    callTotalUnreadChanged(changedConversation: BIMConversation | undefined, bimUnReadInfo: BIMUnReadInfo): void;
    createMessageByType(msgType: number, contentJson: string): Nullable<BIMMessage>;
    createImageLegacyMessage(uir: string): Promise<BIMMessage>;
}

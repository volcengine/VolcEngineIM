import Long from "long";
import { BIMConnectStatus, BIMLiveConversationListener, BIMLiveGroupMarkTypeListener, BIMLiveGroupMemberEventListener, BIMLiveJoinGroupResult, BIMLiveMessageListener, BIMMessage, BIMResult, im_proto, MemberUpdateInfo } from "../../../../../Index";
import { BIMLiveExpandService } from "../api/interface/BIMLiveExpandService";
import { OnPingStatusChangedListener, PingInfo } from "../ping/LiveLifePingManager";
import { CheckFrom } from "../repair/LiveMessageRepairManager";
import { IMSdkContext } from "../../client/IMSdkContext";
import { LiveReceiverMsgMetricsModel } from "../api/metrics/LiveReceiverMsgMetricsModel";
/**
 * 进入直播间的生命周期管理
 * 实例生命周期: 进群开始->退群结束释放
 */
export declare class LiveLifeManager implements OnPingStatusChangedListener {
    private TAG;
    private state;
    private service;
    private liveEventManager;
    private liveLifePingManager;
    private liveMessageRepairManager;
    private messageListener;
    private conversationShortId;
    private lastPingInfo;
    private lastConnectStatus;
    private receiveMsgIndexList;
    private static receiveMsgIndexListLimit;
    private maxLeakListSize;
    private context;
    private bimClient;
    private uploadingMsg;
    constructor(context: IMSdkContext, service: BIMLiveExpandService);
    static setReceiveMsgIndexListLimit(limit: number): void;
    addUploadingMsg(msgId: string): void;
    removeUploadingMsg(msgId: string): void;
    isValidMsg(msgId: string): boolean;
    log(content: string): void;
    /**
     * 用户主动调用
     *
     * @param shorId
     * @param memberInfo
     * @param callback
     * @param messageListener
     * @param memberEventListener
     * @param conversationListListener
     */
    join(shorId: string, memberInfo: MemberUpdateInfo | undefined, messageListener: BIMLiveMessageListener, memberEventListener: BIMLiveGroupMemberEventListener, conversationListListener: BIMLiveConversationListener, markTypeListener: BIMLiveGroupMarkTypeListener): Promise<BIMResult<BIMLiveJoinGroupResult | undefined>>;
    /**
     * 用户主动调用
     *
     * @param callback
     */
    leave(): Promise<BIMResult<boolean>>;
    /**
     * 发息外部调用
     *
     * @param message
     */
    onSendMessage(message: BIMMessage): void;
    /**
     * 外部调用
     *
     * @param message
     */
    onUpdateMessage(message: BIMMessage): void;
    /**
     * 外部调用修复补偿的消息(拉取）
     *
     * @param message
     */
    onRepairedMessage(body: im_proto.IMessageBody): void;
    /**
     * 外部调用服务端删除消息
     */
    onDeleteMessage(message: BIMMessage): void;
    /**
     * 外部调用
     *
     * @param body
     */
    onNotifyMessage(body: im_proto.IMessageBody, model: LiveReceiverMsgMetricsModel): void;
    private handleMessageBody;
    private checkInvisible;
    /**
     * 发送端调用发送接口时间
     *
     * @return
     */
    private getSTime;
    /**
     * 内部调用
     * 重新加入，作为补偿用。
     * 1、长链断开后端会移除用户，长连接波动需做补偿。
     * 2、后端允许在群的用户重复加入。
     */
    rejoin(from: CheckFrom): Promise<void>;
    /**
     * 长连接状态变化
     *
     * @param status
     */
    onConnectChanged(status: BIMConnectStatus): void;
    /**
     * 外部调用
     *
     * @param pingInfo
     */
    onPingStatusChanged(pingInfo: PingInfo): void;
    private computeLeakIndex;
    checkMsgAnd(indexV2: Long): void;
    private monitorReceiveMsgEvent;
}

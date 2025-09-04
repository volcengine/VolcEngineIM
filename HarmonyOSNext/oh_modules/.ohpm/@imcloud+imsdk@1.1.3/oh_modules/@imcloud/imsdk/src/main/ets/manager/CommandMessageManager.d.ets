import { ICommandMessage } from '../api/bean/command/CommandMessage';
import { Message } from '../api/model/Message';
import { im_proto } from '../api/proto';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
/**
 * 处理命令消息
 */
export declare class CommandMessageManager extends IMSdkBaseObject {
    constructor(context: IMSdkContext);
    static isCommandMsg(messageBody: im_proto.IMessageBody | undefined): boolean;
    handle(messageBody: im_proto.IMessageBody, msgSource: number): Promise<boolean>;
    /**
     * 收到一个将某个「不可见消息」变可见的命令消息
     * @param msg
     */
    private handleMsgVisible;
    private updateMsgBySinglePull;
    /***
     * 检查check_message/check_code是否有更新
     * @returns true存在更新
     */
    updateCheckMessage(message: Message, checkJson: string): Promise<boolean>;
    /**
     * 对齐Android convertMuteMessageType
     * @param value
     * @returns
     */
    private getMuteMessageTypeFromValue;
    private handleCommand;
    private diffMembers;
    private updateSubInfo;
    private updateGroup;
    updateGroupMember(cmdMessage: ICommandMessage, messageBody: im_proto.IMessageBody): Promise<void>;
    private deleteMessage;
    private deleteLastHintMessage;
    private updateConversation;
    private deleteConversation;
    private handleUpdate;
    private dissolveConversation;
    private handleUpdateProperty;
    /**
     * 群聊全局配置更新：禁言
     * @param messageBody
     */
    private handleBlock;
    private handleMark;
    /**
     * 处理消息发送失败，服务端推送命令消息
     * check下这个背景：为啥会有这个命令消息？以及是不是一个兜底的补充方案
     * @param messageBody
     */
    private handleSendFailedResp;
    /**
     * 通话来电命令消息
     * MESSAGE_TYPE_NOTIFY_VOIP_COMMAND(50018)
     * inside content:
     * {
     * "inbox_type": inbox,
     * "conversation_id": "会话 id",
     * "conversation_type": 会话类型,
     * "message_id": 指定消息id
     * }
     * @param messageBody
     * @param msgSource
     */
    private handleVoipCommand;
    /**
     * 通知一起看房间结束
     * MESSAGE_TYPE_NOTIFY_TOGETHER_END_COMMAND(50020)
     * inside content:
     * json:
     * {
     * "conv_short_id_list":[int64,int64],     // 要回滚的会话列表，没有就是所有会话
     * "earliest_timestamp_ms":int64,              // 出问题区间最旧时间
     * "latest_timestamp_ms":int64,                // 出问题区间最新时间
     * "page_size": int32,                      // 每请求拉取大小
     * "min_version": "210000",                 // 没有就是无限制。
     * "max_version": "210000",                 // 没有就是无限制。
     * "platform_list": ["android","ios"]       // 要回滚的平台，没有就是无限制。
     * "app_id_list":[(int32)app1,app2],         // 要回滚的app，没有就是所有
     * "roll_version":int64(时间戳）             // 客户端去重用
     * }
     */
    private feedShareEndCommand;
    /**
     * 覆盖回滚端上消息
     * @param messageBody
     * @param msgSource
     */
    private handRollCommand;
    /**
     * inside content:
     * json:
     * {
     * "RoomID":int64,
     * "FromUserID":int64
     * }
     * 音视频在IM中的房间信息更新cmd消息
     */
    private handleMissFeedShareCallCmd;
    /**
     * 更新conversation的minIndex,可能将conversation的minIndex从大到小设置
     * @param messageBody 命令消息内容
     */
    private handleUpdateMinIndexCmd;
    private handleRecallMessage;
    private updateMsg;
    private saveLocalPlaceholderMsg;
    private markConversationReadOp;
    markConversationRead(conversationId: string, conversationType: number, readIndex: bigint, readIndexV2: bigint, readBadgeCount: number, muteReadBadgeCountInfos: Nullable<im_proto.IMuteReadBadgeCountInfo[]>, convUnreadUnion?: Nullable<im_proto.ConvUnreadUnion>): Promise<void>;
}

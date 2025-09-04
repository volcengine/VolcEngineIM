import { im_proto } from '../../proto';
export interface ReceiveMsgExtra {
    metrics?: ReceiveMsgMetrics;
    /**
     * 新混链模式下产生的BadgeCount
     */
    newBadgeCountInRecentLink?: number;
    /**
     * 记录 NewMsgNotifyHandler#notifyModel 向下游通知消息的时间点
     */
    startNotifyModelTime?: number;
}
export declare class ReceiveMsgMetrics {
    traceStruct: TraceStruct;
    msgTracePath: im_proto.MsgTracePath;
    timeCostMap: Map<string, number>;
    isBathOpt: boolean;
    connStatus: number;
    constructor(traceStruct: TraceStruct, msgTracePath: im_proto.MsgTracePath, timeCostMap: Map<string, number>, connStatus: number, isBathOpt?: boolean);
    static newInstance(traceStruct: TraceStruct, msgTracePath: im_proto.MsgTracePath, timeCostMap: Map<string, number>, connStatus: number, isBathOpt?: boolean): void;
}
export declare class TraceStruct {
    innerStorage: Map<number, bigint>;
    appendScene(scene: number, timeStamp: bigint): void;
}
export declare class ReceiveMsgTraceEnum {
    static _CLIENT_START_VALUE: number;
    static _RECEIVE_RAW_DATA_TS: number;
    static _START_DECODE_TS: number;
    static _END_DECODE_TS: number;
    static _RECEIVE_DATA_FROM_IPC_TS: number;
    static _START_DISPATCH_TS: number;
    static _START_SDK_DECODE_TS: number;
    static _END_SDK_DECODE_TS: number;
    static _START_SDK_RECEIVE_TS: number;
    static _END_SDK_RECEIVE_TS: number;
    static _START_PB_LOG_TS: number;
    static _END_PB_LOG_TS: number;
    static _START_EXECUTE_DISPATCH_TS: number;
    static _END_EXECUTE_DISPATCH_TS: number;
    static _START_HANDLE_RSP_TS: number;
    static _START_NOTIFY_USER_TS: number;
    static _START_PROCESS_NOTIFY_TS: number;
    static _START_SAVE_MSG_TS: number;
    static _END_SAVE_MSG_TS: number;
    static _START_UPDATE_CONVERSATION_TS: number;
    static _END_UPDATE_CONVERSATION_TS: number;
    static _START_POST_TO_HANDLE_TS: number;
    static _START_NEW_MSG_NOTIFY_HANDLER: number;
    static _END_NEW_MSG_NOTIFY_HANDLER: number;
    static _START_NEW_MSG_NOTIFY_GET_CONV_INFO: number;
    static _END_NEW_MSG_NOTIFY_GET_CONV_INFO: number;
    static _START_SDK_DECODE_SYSTEM_TS: number;
    static _GATE_WAY_SERVER_TS: im_proto.MsgTraceMetrics;
    static _BEFORE_CALLBACK_SERVER_TS: im_proto.MsgTraceMetrics;
    static _AFTER_CALLBACK_SERVER_TS: im_proto.MsgTraceMetrics;
    static _BEFORE_CONVERSATION_KAFKA_SERVER_TS: im_proto.MsgTraceMetrics;
    static _AFTER_CONVERSATION_KAFKA_SERVER_TS: im_proto.MsgTraceMetrics;
    static _BEFORE_USER_KAFKA_SERVER_TS: im_proto.MsgTraceMetrics;
    static _AFTER_USER_KAFKA_SERVER_TS: im_proto.MsgTraceMetrics;
    static _PUSH_SERVER_TS: im_proto.MsgTraceMetrics;
}
export declare enum NewMsgMetricsEnum {
    KEY_UPDATE_CONVERSATION = "update_conv_total",
    KEY_GET_CONVERSATION = "getConversation",
    KEY_GET_MEMBER_ID = "getMemberId",
    KEY_GET_CORE_INFO = "getCoreInfo",
    KEY_GET_SETTING_INFO = "getSettingInfo",
    KEY_GET_MENTION = "getMentionMsg",
    KEY_GET_KV = "getKv",
    KEY_CALCULATE_SORT_ORDER_MSG = "calSortOrderMsg",
    KEY_FILL_FULL_INFO = "fillFullInfo",
    KEY_SYNC_CONVERSATION_1 = "sync_update_conv_1",
    KEY_IS_CONVERSATION_FORE = "isConversationForeground",
    KEY_IS_CONVERSATION_BACK = "isConversationBackground",
    KEY_UPDATE_CONVERSATION_WHEN_RECV = "updateConversationWhenRecvMsg",
    KEY_AFTER_UPDATE_CONVERSATION_WHEN_RECV = "afterUpdateConversationWhenRecvMsg",
    KEY_HANDLE_STRANGER = "handleStrangerTransfer",
    KEY_SYNC_UPDATE_CONVERSATION = "syncUpdateConversation"
}
export declare enum DiscontinuousMessageSourceEnum {
    RECENT_MSG = 0,
    CONSULT_MSG = 1,
    CMD_MSG = 2,
    MARK_READ_MSG = 3,
    BATCH_RECENT_MSG = 4
}

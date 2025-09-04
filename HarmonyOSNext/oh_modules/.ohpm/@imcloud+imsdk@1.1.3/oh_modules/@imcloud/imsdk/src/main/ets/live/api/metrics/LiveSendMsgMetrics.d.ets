/**
 * @author : chengwuliang@bytedance.com
 * @date : Aug 17, 2020
 */
export declare class LiveSendMsgMetrics {
    /**
     * 消息发送开始时间，ms
     *
     * @see SystemClock#uptimeMillis()
     */
    sdk_start_time: number;
    /**
     * 发送前线程切换耗时，ms
     */
    bs_save_switch_thread_cost_time: number;
    /**
     * 数据库操作结束时间，ms
     *
     * @see SystemClock#uptimeMillis()
     */
    bs_db_operation_finish_time: number;
    /**
     * 发送前线程切换耗时2（从数据库操作线程回到主线程），ms
     */
    bs_save_switch_thread_cost_time_2: number;
    /**
     * 发送前存储耗时（包含线程切换），ms
     */
    bs_save_cost_time: number;
    /**
     * 发送前通知更新会话耗时，ms
     */
    bs_notify_conversation_cost_time: number;
    /**
     * 发送前通知消息发送开始时间，ms
     *
     * @see SystemClock#uptimeMillis()
     */
    bs_notify_msg_sending_start_time: number;
    /**
     * 发送前是否有获取会话信息
     */
    bs_has_fetch_conversation_info: boolean;
    /**
     * 发送前获取会话信息耗时，ms
     */
    bs_fetch_conversation_info_cost_time: number;
    /**
     * 发送前总耗时，ms
     */
    bs_cost_time: number;
    /**
     * Handler网络请求开始时间，ms
     *
     * @see SystemClock#uptimeMillis()
     */
    handler_send_request_start_time: number;
    /**
     * Handler网络请求Response回来时间，ms
     *
     * @see SystemClock#uptimeMillis()
     */
    handler_response_start_time: number;
    /**
     * Handler网络请求耗时，ms
     */
    handler_send_request_cost_time: number;
    /**
     * 发送后Handler处理Response：线程切换耗时，ms
     */
    afs_switch_thread_cost_time: number;
    /**
     * 发送后Handler处理Response：更新消息耗时（包含线程切换），ms
     */
    afs_update_msg_cost_time: number;
    /**
     * 发送后Handler处理Response：更新会话耗时，ms
     */
    afs_notify_conversation_cost_time: number;
    /**
     * 发送后Handler处理Response总耗时，ms
     */
    afs_cost_time: number;
    /**
     * SDK发送完成时间戳，ms
     *
     * @see SystemClock#uptimeMillis()
     */
    sdk_end_time: number;
    /**
     * SDK发送总耗时，ms
     */
    sdk_cost_time: number;
    /**
     * 消息发送push比response先到
     */
    push_before_response: boolean;
    /**
     * 消息发送结果来自push
     */
    from_push: boolean;
    /**
     * 消息是否来自长连（websocket）
     */
    is_ws: boolean;
    /**
     * 服务端是否是异步处理
     */
    is_async_send: boolean;
}

/**
 * @hidden
 * @detail callback
 * @brief 同步服务端会话、消息数据监听。
 */
export interface BIMSyncServerListener {
    /**
     * @detail callback
     * @brief 开始同步服务端会话、消息数据。
     */
    onSyncServerStart: () => void;
    /**
     * @detail callback
     * @brief 同步服务端会话、消息数据成功。
     */
    onSyncServerFinish: () => void;
    /**
     * @detail callback
     * @brief 同步服务端会话、消息数据失败。
     */
    onSyncServerFailed: () => void;
    /**
     * @hidden
     * @detail callback
     * @brief 同步服务端会话、消息数据中。
     */
    onSyncing: () => void;
}

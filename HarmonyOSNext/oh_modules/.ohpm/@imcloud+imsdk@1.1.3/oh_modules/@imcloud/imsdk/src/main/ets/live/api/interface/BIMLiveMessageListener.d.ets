import { BIMMessage } from '../../../../../../Index';
/**
 * @detail callback
 * @brief 消息监听方。
 */
export interface BIMLiveMessageListener {
    /**
     * @detail callback
     * @brief 收到新消息。
     * @param message 消息体，参看 BIMMessage{@link #BIMMessage}。
     */
    onReceiveMessage: (message: BIMMessage) => void;
    /**
     * @detail callback
     * @brief 发送消息入库完成。
     * @param message 消息体，参看 BIMMessage{@link #BIMMessage}。
     */
    onSendMessage: (message: BIMMessage) => void;
    /**
     * @detail callback
     * @brief 收到的消息被删除。
     * @param message 消息体，参看 BIMMessage{@link #BIMMessage}。
     */
    onDeleteMessage: (message: BIMMessage) => void;
    /**
     * @detail callback
     * @brief 收到的消息被修改。（内容+扩展）
     * @param message 消息体，参看 BIMMessage{@link #BIMMessage}。
     */
    onUpdateMessage: (message: BIMMessage) => void;
}

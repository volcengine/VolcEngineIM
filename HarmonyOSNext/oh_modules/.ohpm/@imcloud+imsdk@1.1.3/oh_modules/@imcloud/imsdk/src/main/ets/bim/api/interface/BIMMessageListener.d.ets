import { BIMMessage } from '../model/BIMMessage';
/**
 * @detail callback
 * @brief 消息监听方。
 */
export interface BIMMessageListener {
    /**
     * @detail callback
     * @brief 收到新消息。
     * @param message 消息体，参看 {@link BIMMessage BIMMessage}。
     */
    onReceiveMessage: (message: BIMMessage) => void;
    /**
     * @detail callback
     * @brief 发送消息入库完成。
     * @param message 消息体，参看 {@link BIMMessage BIMMessage}。
     */
    onSendMessage: (message: BIMMessage) => void;
    /**
     * @detail callback
     * @brief 收到的消息被删除。
     * @param message 消息体，参看 {@link BIMMessage BIMMessage}。
     */
    onDeleteMessage: (message: BIMMessage) => void;
    /**
     * @detail callback
     * @brief 收到的消息被撤回。
     * @param message 消息体，参看 {@link BIMMessage BIMMessage}。
     */
    onRecallMessage: (message: BIMMessage) => void;
    /**
     * @detail callback
     * @brief 收到的消息被修改。（内容+扩展）
     * @param message 消息体，参看 {@link BIMMessage BIMMessage}。
     */
    onUpdateMessage: (message: BIMMessage) => void;
}

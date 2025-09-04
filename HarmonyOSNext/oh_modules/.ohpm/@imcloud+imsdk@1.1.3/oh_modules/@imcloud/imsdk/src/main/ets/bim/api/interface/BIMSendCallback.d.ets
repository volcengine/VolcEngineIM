import { BIMErrorCode } from '../enum/BIMErrorCode';
import { BIMMessage } from '../model/BIMMessage';
/**
 * @detail callback
 * @brief 发送结果回调。
 */
export interface BIMSendCallback {
    /**
     * @detail callback
     * @brief 媒体消息上传进度。
     * @param message 消息体，参看 {@link BIMMessage BIMMessage}。
     * @param progress 上传进度。
     */
    onProgress: (message: BIMMessage, progress: number) => void;
    /**
     * @detail callback
     * @brief 消息已保存。
     * @param bimMessage 消息体，参看 {@link BIMMessage BIMMessage}。
     */
    onSaved: (message: BIMMessage) => void;
    /**
     * @detail callback
     * @brief 消息发送成功。
     * @param bimMessage 消息体，参看 {@link BIMMessage BIMMessage}。
     */
    onSuccess: (message: BIMMessage) => void;
    /**
     * @detail callback
     * @brief 消息发送失败。
     * @param bimMessage 消息体，参看 {@link BIMMessage BIMMessage}。
     * @param code 错误码，参看 {@link BIMErrorCode BIMErrorCode}。
     */
    onError: (message: BIMMessage, code: BIMErrorCode) => void;
}

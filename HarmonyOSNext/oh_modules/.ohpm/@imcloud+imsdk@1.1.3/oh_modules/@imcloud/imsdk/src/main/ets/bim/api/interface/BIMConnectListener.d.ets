import { BIMConnectStatus } from '../enum/BIMConnectStatus';
import { BIMErrorCode } from '../enum/BIMErrorCode';
/**
 * @detail callback
 * @brief 长链状态监听方。
 */
export interface BIMConnectListener {
    /**
     * @detail callback
     * @brief 长链状态改变回调。
     * @param status 长链状态码, 参看 {@link BIMConnectStatus BIMConnectStatus}。
     */
    onConnectStatusChanged: (status: BIMConnectStatus) => void;
    /**
     * @detail callback
     * @brief Token 失效回调。
     * @param code Token 过期错误码, 参看 {@link BIMErrorCode BIMErrorCode}。
     */
    onTokenInvalid: (code: BIMErrorCode) => void;
}

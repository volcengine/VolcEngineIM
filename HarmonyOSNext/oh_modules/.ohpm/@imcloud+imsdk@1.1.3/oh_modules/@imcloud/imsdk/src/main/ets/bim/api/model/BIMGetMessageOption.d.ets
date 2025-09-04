import { BIMMessage } from './BIMMessage';
/**
 * @detail keytype
 * @brief 获取消息选项。
 */
export declare class BIMGetMessageOption {
    /**
     * @brief 获取消息数量。
     */
    limit: number;
    /**
     * @brief 获取起点。
     */
    anchorMessage: BIMMessage | undefined;
    /**
     * @hidden
     */
    isNeedServer: boolean;
}

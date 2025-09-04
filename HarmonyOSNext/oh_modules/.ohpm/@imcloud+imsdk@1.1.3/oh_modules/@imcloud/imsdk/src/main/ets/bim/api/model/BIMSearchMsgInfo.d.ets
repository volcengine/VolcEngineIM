import { BIMMessage } from "./BIMMessage";
import { BIMSearchDetail } from "./BIMSearchDetail";
/**
 * @detail keytype
 * @brief 消息搜索结果
 */
export declare class BIMSearchMsgInfo {
    /**
     * @brief 搜索到的消息。
     */
    message: BIMMessage | undefined;
    /**
     * @brief 消息搜索详情.
     */
    searchDetail: BIMSearchDetail | undefined;
}

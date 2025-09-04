import { LocalPropertyItem } from '../../../api/model/MessageProperty';
/**
 * @detail keytype
 * @brief 消息属性
 */
export declare class BIMMessagePropertyItem {
    /**
     * @hidden
     */
    private innerItem;
    /**
     * @hidden
     */
    constructor(item: LocalPropertyItem);
    /**
     * @return 用户id。
     * @detail api
     * @brief 获取用户id。
     */
    getSender(): string;
    /**
     * @return 创建时间。
     * @detail api
     * @brief 获取创建时间。
     */
    getCreateAt(): number;
    /**
     * @return 幂等 ID，用来做去重、取消等；业务方自定义，需确保唯一性，SDK内部仅透传。
     * @detail api
     * @brief 获取幂等 ID。
     */
    getIdempotentId(): string;
    /**
     * @return property值。
     * @detail api
     * @brief 获取property值。
     */
    getValue(): string;
}

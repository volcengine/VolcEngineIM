import { BIMMessageNewPropertyModifyType } from '../enum/BIMMessageNewPropertyModifyType';
/**
 * @detail keytype
 * @brief 消息属性修改信息。
 */
export declare class BIMMessageNewPropertyModify {
    /**
     * @brief 属性的key值
     */
    key: string;
    value: string;
    /**
     * @brief 幂等 ID，用来做去重、取消等；业务方自定义，需确保唯一性，SDK 只负责透传
     */
    idempotentID: string;
    /**
     * @brief 属性修改的类型，参看 {@link BIMMessageNewPropertyModifyType BIMMessageNewPropertyModifyType}。
     */
    type: BIMMessageNewPropertyModifyType;
}

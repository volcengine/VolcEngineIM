import { im_proto } from '../../../api/proto';
import { BIMMessageType } from '../enum/BIMMessageType';
import { BIMMessage } from './BIMMessage';
/**
 * @detail keytype
 * @brief 引用消息状态。
 */
export declare enum BIMReferenceMessageStatus {
    /**
     * @brief 消息存在。
     */
    BIM_REFERENCE_MESSAGE_STATUS_AVAILABLE = 0,
    /**
     * @brief 消息不存在。
     */
    BIM_REFERENCE_MESSAGE_STATUS_NOTEXIST = 1,
    /**
     * @brief 消息（对用户）不可见。
     */
    BIM_REFERENCE_MESSAGE_STATUS_INVISIBLE = 2,
    /**
     * @brief 消息被撤回。
     */
    BIM_REFERENCE_MESSAGE_STATUS_RECALLED = 3,
    /**
     * @brief 消息被删除。
     */
    BIM_REFERENCE_MESSAGE_STATUS_DELETED = 4
}
/**
 * @detail keytype
 * @brief 引用消息信息。
 */
export declare class BIMReferenceInfo {
    /**
     * @hidden
     */
    private referenceInfo;
    /**
     * @hidden
     */
    constructor(referenceInfo: im_proto.IReferenceInfo);
    /**
     * @return 引用消息内容
     * @detail api
     * @brief 获取引用消息
     */
    getRefMessage(): BIMMessage | undefined;
    /**
     * @return 引用消息 serverMessageID。
     * @detail api
     * @brief 获取引用消息 serverMessageID。
     */
    getServerMessageID(): bigint;
    /**
     * @return 引用消息类型，参看 {@link BIMMessageType BIMMessageType}。
     * @detail api
     * @brief 获取引用消息类型。
     */
    getMessageType(): BIMMessageType;
    /**
     * @return 引用消息 hint。
     * @detail api
     * @brief 获取引用消息 hint。
     */
    getHint(): string;
    /**
     * @return 引用消息状态。
     * @detail api
     * @brief 获取引用消息状态。
     */
    getRefStatus(): BIMReferenceMessageStatus;
}

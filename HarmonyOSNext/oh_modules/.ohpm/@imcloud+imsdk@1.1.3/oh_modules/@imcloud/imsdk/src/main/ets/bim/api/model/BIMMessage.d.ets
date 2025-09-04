import { Conversation } from '../../../api/model/Conversation';
import { Message } from '../../../api/model/Message';
import { BIMConversationType } from '../enum/BIMConversationType';
import { BIMMessageStatus } from '../enum/BIMMessageStatus';
import { BIMMessageType } from '../enum/BIMMessageType';
import { BIMEditInfo } from './BIMEditInfo';
import { BIMMessagePropertyItem } from './BIMMessagePropertyItem';
import { BIMReferenceInfo } from './BIMReferenceInfo';
import { BIMBaseElement } from './element/BIMBaseElement';
import { BIMMessagePriority } from '../../../../../../Index';
/**
 * @detail keytype
 * @brief 消息体。
 */
export declare class BIMMessage {
    /**
     * @hidden
     */
    readonly tag = "BIMMessage";
    /**
     * @hidden
     */
    private _innerMessage;
    /**
     * @hidden
     */
    get innerMessage(): Message;
    /**
     * @hidden
     */
    private content;
    /** @hidden */
    private priority;
    /**
     * @hidden
     */
    constructor(innerMessage: Message);
    /**
     * @return 消息排序 index。
     * @detail api
     * @brief 消息排序 index。
     */
    getOrderIndex(): string;
    /**
     * @return 消息创建时间。
     * @detail api
     * @brief 消息创建时间。
     */
    getCreatedTime(): number;
    /**
     * @return 消息类型，参看 {@link BIMMessageType BIMMessageType}。
     * @detail api
     * @brief 获取消息类型。
     */
    getMsgType(): BIMMessageType;
    /**
     * @return 消息发送者 userID。
     * @detail api
     * @brief 消息发送者 userID
     */
    getSenderUID(): string;
    /**
     * @hidden
     */
    buildConversation(conversation: Conversation): void;
    /**
     * @return 消息客户端 ID
     * @detail api
     * @brief 消息客户端 ID
     */
    getUuid(): string;
    /**
     * @detail api
     * @brief 获取消息服务端 ID
     * @return 消息状态服务端 ID
     */
    getServerMsgId(): string;
    /**
     * @detail api
     * @brief 获取消息状态
     * @return 消息状态，参看 {@link BIMMessageStatus BIMMessageStatus}。
     */
    getMsgStatus(): BIMMessageStatus;
    /**
     * @detail api
     * @brief 消息所属的会话 ID
     * @return 消息所属的会话 ID
     */
    getConversationID(): string;
    /**
     * @detail api
     * @brief 获取消息所对应的会话 shortID
     * @return 消息所对应的会话 shortID
     */
    getConversationShortID(): string;
    /**
     * @detail api
     * @brief 获取会话类型
     * @return 会话类型
     */
    getConversationType(): BIMConversationType;
    /**
     * @detail api
     * @brief 获取消息是否被撤回
     * @return 是否被撤回
     */
    isRecalled(): boolean;
    /**
     * @detail api
     * @return 消息 Element, 参看 {@link BIMBaseElement BIMBaseElement}
     * @brief 获取消息 Element 数据。
     */
    getElement(): BIMBaseElement;
    /**
     * @hidden
     */
    getContentData(): string;
    /**
     * @return 引用信息。
     * @detail api
     * @brief 获取引用信息，参看 {@link BIMReferenceInfo BIMReferenceInfo}
     */
    getReferenceInfo(): BIMReferenceInfo | undefined;
    /**
     * @detail api
     * @brief 获取消息额外携带数据
     * @return 消息额外携带数据
     */
    getExtra(): Map<string, string>;
    /**
     * @detail api
     * @brief 获取消息 at 用户列表
     * @return 消息 at 用户列表
     */
    getMentionUIDList(): string[];
    /**
     * @detail api
     * @brief 获取编辑信息
     * @return 获取编辑信息,如未被编辑则返回 null
     */
    getEditInfo(): BIMEditInfo | undefined;
    /**
     * @detail api
     * @brief 获取消息属性信息。
     * @return 消息属性信息，每个消息可能有多个属性，key 为属性名称，value 是该属性所对应的消息属性列表，消息属性参看 {@link BIMMessagePropertyItem BIMMessagePropertyItem}。
     */
    getProperties(): Map<string, BIMMessagePropertyItem[]>;
    /**
     * @detail api
     * @brief 本地的扩展信息
     * @return 本地的扩展信息，仅在当前设备生效
     */
    getLocalExt(): Map<string, string>;
    /**
     * @detail api
     * @brief 消息版本号
     * @return 消息版本号
     */
    getVersion(): number;
    /**
     * @hidden
     */
    setPriority(priority: BIMMessagePriority): void;
    /**
     * @hidden
     */
    getPriority(): BIMMessagePriority;
}

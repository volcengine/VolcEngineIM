/**
 * @see LoadHistoryMsgHandler
 */
import Long from 'long';
import { im_proto } from '../../api/proto';
/**
 * 301接口请求参数
 */
export interface LoadHistoryMsgParams {
    /**
     * 需要拉取历史消息的「会话的ID」
     */
    conversationId: string;
    /**
     * 本次需要拉取多少条消息
     */
    limit: number;
    /**
     * 从会话的哪一条消息处开始拉消息，对应的消息index_in_conversation
     * version v1
     * 对应 {@link MessageBody#index_in_conversation}
     */
    oldMsgIndexInConversation: Long;
    /**
     * 加载方向
     */
    direction: im_proto.MessageDirection;
}

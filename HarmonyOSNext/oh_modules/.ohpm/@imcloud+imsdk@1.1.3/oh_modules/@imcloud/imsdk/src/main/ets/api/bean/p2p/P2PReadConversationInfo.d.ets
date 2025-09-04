import { Message } from '../../model/Message';
import { P2PReadNotifyContent } from './P2PReadNotifyContent';
export declare class P2PReadConversationInfo {
    conversationId: Nullable<string>;
    conversationShortId: Nullable<bigint>;
    conversationType: Nullable<number>;
    inboxType: number;
    contentMap: Nullable<Map<bigint, P2PReadNotifyContent>>;
    lastSendMsg: Nullable<Message>;
}

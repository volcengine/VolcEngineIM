import { Conversation } from '../api/model/Conversation';
import { Message } from '../api/model/Message';
import { im_proto } from '../api/proto';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare class StrangerUtil extends IMSdkBaseObject {
    constructor(context: IMSdkContext);
    convertStrangerConversation(recentMsg: im_proto.IConversationRecentMessage, lastMsg: Message): Promise<Conversation>;
    updateStrangerConversation(conversation: Conversation, recentMsg: im_proto.IConversationRecentMessage, lastMsg: Message): Promise<void>;
    updateStrangerByMode(conversation?: Conversation): void;
    checkStrangerByMode(conversationId: Nullable<string>, mode: number): boolean;
}

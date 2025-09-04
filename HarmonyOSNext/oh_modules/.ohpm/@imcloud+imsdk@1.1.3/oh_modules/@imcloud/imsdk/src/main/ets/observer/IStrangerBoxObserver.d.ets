import { Conversation } from '../api/model/Conversation';
export declare class StrangerBox {
    totalUnread: number;
    latestConversation: Conversation;
    strangerConversationList: Conversation[];
    constructor(t: number, latestC: Conversation, convList: Conversation[]);
    equals(oldBox: StrangerBox): boolean;
}
export interface IStrangerBoxObserver {
    onStrangerBoxUpdate: (strangerBox: StrangerBox) => void;
}

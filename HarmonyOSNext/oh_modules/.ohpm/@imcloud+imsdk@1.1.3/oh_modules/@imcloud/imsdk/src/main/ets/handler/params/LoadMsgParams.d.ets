import Long from 'long';
/**
 * @see LoadMessageHandler
 */
export interface LoadMsgParams {
    conversationId: string;
    conversationShortId: Long;
    conversationType: number;
    direction: number;
    inboxType: number;
    anchorIndex: Long;
    limit: number;
}

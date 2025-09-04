/**
 * @see GetConversationInfoHandler
 */
export interface GetConversationInfoParams {
    inboxType: number;
    conversationId: string;
    conversationShortId: bigint;
    conversationType: number;
    updateTime: number;
    badgeCount: number;
    force: boolean;
    filterLocalMap?: Map<string, string>;
}

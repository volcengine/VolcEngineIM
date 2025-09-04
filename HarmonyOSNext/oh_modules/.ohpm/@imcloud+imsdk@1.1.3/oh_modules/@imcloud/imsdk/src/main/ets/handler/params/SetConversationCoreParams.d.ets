export interface SetConversationCoreParams {
    /**
     * 需要拉取历史消息的「会话的ID」
     */
    conversationId: string;
    name?: string;
    desc?: string;
    notice?: string;
    icon?: string;
    extParam?: Map<string, string>;
}

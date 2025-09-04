import Long from "long";
export interface CreateConversationMemberBean {
    userId: Long;
    bizRole: string;
    groupSymbol: number;
}

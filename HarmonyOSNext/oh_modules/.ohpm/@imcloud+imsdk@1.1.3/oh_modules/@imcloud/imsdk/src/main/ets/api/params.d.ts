import type * as Long from 'long';
import type { im_proto } from './proto';
export interface InboxTypeParams {
    inboxType: number;
}
export type CreateConversationParams = {
    type: im_proto.ConversationType;
    participants: Long[];
    persistent?: boolean;
    idempotentId?: string;
    name?: string;
    avatarUrl?: string;
    desc?: string;
    bizExt?: {
        [k: string]: string;
    };
} & InboxTypeParams;
export type GetMessagesByUserParams = {
    cursor?: Long;
    limit: number;
} & InboxTypeParams;
export type GetMessagesByUserInitV2Params = {
    cursor?: Long;
    initSubType?: number;
    convLimit?: number;
    msgLimit?: number;
    tagIds?: Long[];
    userCustomTagIds?: Long[];
} & InboxTypeParams;
export type GetMessagesByInit = {
    version?: Long;
    page?: number;
    convLimit?: number;
    msgLimit?: number;
} & InboxTypeParams;
export type ConversationParams = {
    conversationId: string;
    conversationType?: im_proto.ConversationType;
    conversationShortId?: Long;
} & InboxTypeParams;
export type GetMessagesByConversationParams = {
    limit?: number;
    anchorIndex?: Long;
    direction: im_proto.MessageDirection;
} & ConversationParams;
export type MarkConversationReadParams = {
    readIndex: Long;
    unreadCount?: Long;
    totalUnreadCount?: Long;
    readBadgeCount?: number;
    readIndexV2: Long;
    muteReadBadgeCountInfos?: im_proto.IMuteReadBadgeCountInfo[] | undefined;
} & ConversationParams;
export type SendMessageParams = {
    content: string;
    ext?: {
        [k: string]: string;
    };
    messageType: im_proto.MessageType;
    ticket: string;
    clientId: string;
    mentionedUsers: Long[];
    referenceInfo?: im_proto.IReferenceInfo;
} & ConversationParams;
export type GetConversationInfoListParmas = {
    conversations: ConversationParams[];
} & InboxTypeParams;
export type RecallMessageParams = ConversationParams & {
    serverId: Long;
};
export type GetCoreInfoParams = ConversationParams;
export type GetTicketParams = {
    conversationType: im_proto.ConversationType;
    shortId: Long;
    toId: Long;
    ext?: {
        [k: string]: string;
    };
} & InboxTypeParams;
export type ConversationParticipantsListParams = {
    cursor: Long;
    limit: number;
} & ConversationParams;
export type GetConversationParticipantByUserIdParams = {
    participants?: Long[];
} & ConversationParams;
export type BatchGatConversationParticipantsReadIndexParams = {
    conversationId: string[] | undefined;
    conversationShortId: Long[] | undefined;
    request_from?: string;
    min_index_required?: boolean;
};
export type GetUserMessageParams = {
    version?: Long;
    cmdIndex?: Long;
    readVersion?: Long;
    source: string;
} & InboxTypeParams;

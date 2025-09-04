import { im_proto } from '../../proto';
export interface ICommandMessage {
    command_type: number;
    inbox_type: number;
    conversation_id: string;
    conversation_type: number;
    message_id: string;
    read_index: string;
    read_index_v2: string;
    read_badge_count: number;
    unread_count: number;
    conv_unread_union: im_proto.ConvUnreadUnion;
    last_message_index: string;
    last_message_index_v2: string;
    conversation_version: string;
    group_version: string;
    added_participant: string[];
    modified_participant: string[];
    removed_participant: string[];
    mute_read_badge_count_info: CommandMsgMuteReadBadgeCountInfo[];
    version: string;
}
export interface CommandMsgMuteReadBadgeCountInfo {
    type: number;
    read_badge_count: number;
}
export declare class BaseGroupInfo {
    commandType: string;
    conversationIcon: string;
    conversationId: string;
    conversationName: string;
    conversationType: string;
    ext: Map<string, string>;
    groupVersion: string;
    inboxType: string;
    constructor(contentStr: string);
}

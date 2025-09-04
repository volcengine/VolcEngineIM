import { im_proto } from '../proto';
export declare enum PropertyStatus {
    Sending = 1,
    Success = 2,
    Failed = 3,
    CHANGED = 4
}
export declare class LocalPropertyItem {
    msgUuid: string;
    conversationId: string;
    uid: bigint;
    secUid: string;
    createTime?: number;
    idempotentId: string;
    key: string;
    value: string;
    version: bigint;
    status: PropertyStatus;
    deleted: number;
}
export declare class ModifyMsgPropertyMsg {
    conversationId: Nullable<string>;
    conversationType: Nullable<number>;
    conversationShortId: Nullable<bigint>;
    serverMessageId: Nullable<bigint>;
    clientMessageId: Nullable<string>;
    propertyContentList: Nullable<im_proto.ModifyPropertyContent[]>;
    ticket: Nullable<string>;
    inboxType: Nullable<number>;
    msgType: Nullable<number>;
    modifyMsgPropertyStatus: Nullable<im_proto.ModifyMessagePropertyStatus>;
    mute: Nullable<boolean>;
    removePropertyContent(localPropertyItem: Nullable<LocalPropertyItem>): void;
    addPropertyContent(localPropertyItem: Nullable<LocalPropertyItem>): void;
    copy(): ModifyMsgPropertyMsg;
    toString(): string;
}

import { DBColumn } from './DBColumn';
export declare class MessageAttachmentConfig {
    static readonly TABLE_NAME = "attachment";
    static readonly COLUMN_UUID: DBColumn;
    static readonly COLUMN_LOCAL_URI: DBColumn;
    static readonly COLUMN_REMOTE_URI: DBColumn;
    static readonly COLUMN_SIZE: DBColumn;
    static readonly COLUMN_TYPE: DBColumn;
    static readonly COLUMN_HASH: DBColumn;
    static readonly COLUMN_INDEX: DBColumn;
    static readonly COLUMN_STATUS: DBColumn;
    static readonly COLUMN_EXT: DBColumn;
    static readonly COLUMN_DISPLAY_TYPE: DBColumn;
    static readonly COLUMN_MIME_TYPE: DBColumn;
    static readonly COLUMN_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static readonly COLUMN_LIST_BIG_INT: string[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

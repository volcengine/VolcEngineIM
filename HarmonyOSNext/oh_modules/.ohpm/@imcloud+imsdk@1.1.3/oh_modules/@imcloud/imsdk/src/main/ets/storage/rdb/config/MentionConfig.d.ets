import { DBColumn } from './DBColumn';
export declare class MentionConfig {
    static readonly TABLE_NAME = "mention";
    static readonly COLUMN_MSG_UUID: DBColumn;
    static readonly COLUMN_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_IDS_STR: DBColumn;
    static readonly COLUMN_CREATED_TIME: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

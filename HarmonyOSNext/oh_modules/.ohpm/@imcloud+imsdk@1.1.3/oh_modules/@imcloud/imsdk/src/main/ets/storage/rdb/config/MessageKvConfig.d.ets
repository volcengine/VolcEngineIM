import { DBColumn } from './DBColumn';
export declare class MessageKvConfig {
    static readonly TABLE_NAME = "message_kv";
    static readonly COLUMN_MSG_UUID: DBColumn;
    static readonly COLUMN_KEY: DBColumn;
    static readonly COLUMN_VALUE: DBColumn;
    static readonly COLUMN_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

import { DBColumn } from './DBColumn';
export declare class ConversationKvConfig {
    static readonly TABLE_NAME = "conversation_kv";
    static readonly COLUMN_CONV_ID: DBColumn;
    static readonly COLUMN_KEY: DBColumn;
    static readonly COLUMN_VALUE: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

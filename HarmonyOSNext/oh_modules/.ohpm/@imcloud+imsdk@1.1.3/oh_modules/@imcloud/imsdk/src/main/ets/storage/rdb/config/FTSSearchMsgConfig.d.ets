import { DBFtsColumn } from './DBColumn';
export declare class FTSSearchMsgConfig {
    static readonly TABLE_NAME = "fts_msg_index_table";
    static readonly COLUMN_MSG_UUID: DBFtsColumn;
    static readonly COLUMN_CONVERSATION_ID: DBFtsColumn;
    static readonly COLUMN_CREATED_TIME: DBFtsColumn;
    static readonly COLUMN_SEARCH_CONTENT: DBFtsColumn;
    static readonly COLUMN_LIST: DBFtsColumn[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

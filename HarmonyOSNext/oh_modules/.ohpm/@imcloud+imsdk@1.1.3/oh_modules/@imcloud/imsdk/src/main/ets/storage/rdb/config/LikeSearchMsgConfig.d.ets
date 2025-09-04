import { DBColumn } from './DBColumn';
export declare class LikeSearchMsgConfig {
    static readonly TABLE_NAME = "like_search_msg_table";
    static readonly COLUMN_MSG_UUID: DBColumn;
    static readonly COLUMN_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_CREATED_TIME: DBColumn;
    static readonly COLUMN_SEARCH_CONTENT: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

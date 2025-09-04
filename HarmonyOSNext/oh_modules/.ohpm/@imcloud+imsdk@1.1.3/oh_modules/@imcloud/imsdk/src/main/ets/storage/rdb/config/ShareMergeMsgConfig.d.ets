import { DBColumn } from './DBColumn';
export declare class ShareMergeMsgConfig {
    static readonly TABLE_NAME = "share_merge_msg";
    static readonly COLUMN_SERVER_ID: DBColumn;
    static readonly COLUMN_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_MSG_DATA: DBColumn;
    static readonly COLUMN_CREATED_TIME: DBColumn;
    static readonly COLUMN_REQUEST_TIME: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

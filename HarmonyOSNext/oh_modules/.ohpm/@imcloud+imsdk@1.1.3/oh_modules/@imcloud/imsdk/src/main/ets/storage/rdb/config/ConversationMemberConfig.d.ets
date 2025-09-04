import { DBColumn } from './DBColumn';
export declare class ConversationMemberConfig {
    static readonly TABLE_NAME = "participant";
    static readonly COLUMN_USER_ID: DBColumn;
    static readonly COLUMN_SORT_ORDER: DBColumn;
    static readonly COLUMN_ROLE: DBColumn;
    static readonly COLUMN_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_ALIAS: DBColumn;
    static readonly COLUMN_SEC_UID: DBColumn;
    static readonly COLUMN_SILENT: DBColumn;
    static readonly COLUMN_SILENT_TIME: DBColumn;
    static readonly COLUMN_USER_LOCAL_CREATE_TIME: DBColumn;
    static readonly COLUMN_MENTION_TIME: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static readonly COLUMN_LIST_BIG_INT: string[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

import { DBColumn } from './DBColumn';
export declare class ConversationCoreConfig {
    static readonly TABLE_NAME = "conversation_core";
    static readonly COLUMN_ID: DBColumn;
    static readonly COLUMN_VERSION: DBColumn;
    static readonly COLUMN_NAME: DBColumn;
    static readonly COLUMN_DESC: DBColumn;
    static readonly COLUMN_ICON: DBColumn;
    static readonly COLUMN_NOTICE: DBColumn;
    static readonly COLUMN_OWNER_ID: DBColumn;
    static readonly COLUMN_SEC_OWNER: DBColumn;
    static readonly COLUMN_SILENT: DBColumn;
    static readonly COLUMN_SILENT_NORMAL_ONLY: DBColumn;
    static readonly COLUMN_MODE: DBColumn;
    static readonly COLUMN_EXT: DBColumn;
    static readonly COLUMN_CREATOR_UID: DBColumn;
    static readonly COLUMN_CREATE_TIME: DBColumn;
    static readonly COLUMN_SILENT_SOURCE: DBColumn;
    static readonly COLUMN_SILENT_UNTIL_TIME: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static readonly COLUMN_LIST_BIG_INT: string[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

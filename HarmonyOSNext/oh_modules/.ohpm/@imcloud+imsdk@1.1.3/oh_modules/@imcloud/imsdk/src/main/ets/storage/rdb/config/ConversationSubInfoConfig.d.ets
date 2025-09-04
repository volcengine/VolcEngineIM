import { DBColumn } from './DBColumn';
export declare class ConversationSubInfoConfig {
    static readonly TABLE_NAME = "conversation_sub_info";
    static readonly COLUMN_SHORT_ID: DBColumn;
    static readonly COLUMN_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_PARENT_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_PARENT_SHORT_ID: DBColumn;
    static readonly COLUMN_CONVERSATION_TYPE: DBColumn;
    static readonly COLUMN_STATUS: DBColumn;
    static readonly COLUMN_BIZ_STATUS: DBColumn;
    static readonly COLUMN_CREATE_TIME: DBColumn;
    static readonly COLUMN_MODIFY_TIME: DBColumn;
    static readonly COLUMN_EXTRA: DBColumn;
    static readonly COLUMN_INBOX_TYPE: DBColumn;
    static readonly COLUMN_VERSION: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

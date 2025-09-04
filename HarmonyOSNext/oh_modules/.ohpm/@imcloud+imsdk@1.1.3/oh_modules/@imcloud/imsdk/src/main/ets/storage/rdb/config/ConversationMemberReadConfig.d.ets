import { DBColumn } from './DBColumn';
export declare class ConversationMemberReadConfig {
    static readonly TABLE_NAME = "participant_read";
    static readonly COLUMN_USER_ID: DBColumn;
    static readonly COLUMN_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_MIN_INDEX_V1: DBColumn;
    static readonly COLUMN_READ_INDEX_V1: DBColumn;
    static readonly COLUMN_READ_ORDER_INDEX: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static readonly COLUMN_LIST_BIG_INT: string[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

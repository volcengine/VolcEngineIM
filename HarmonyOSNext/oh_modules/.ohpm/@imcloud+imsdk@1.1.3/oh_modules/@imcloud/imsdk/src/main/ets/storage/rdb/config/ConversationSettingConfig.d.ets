import { DBColumn } from './DBColumn';
export declare class ConversationSettingConfig {
    static readonly TABLE_NAME = "conversation_setting";
    static readonly COLUMN_ID: DBColumn;
    static readonly COLUMN_VERSION: DBColumn;
    static readonly COLUMN_STICK_TOP: DBColumn;
    static readonly COLUMN_MUTE: DBColumn;
    static readonly COLUMN_EXT: DBColumn;
    static readonly COLUMN_FAVORITE: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static readonly COLUMN_LIST_BIG_INT: string[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

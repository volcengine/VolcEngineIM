import { DBColumn } from './DBColumn';
export declare class MessagePropertyConfig {
    static readonly TABLE_NAME = "msg_property";
    static readonly COLUMN_MSG_UUID: DBColumn;
    static readonly COLUMN_CONVERSATION_ID: DBColumn;
    static readonly COLUMN_KEY: DBColumn;
    static readonly COLUMN_IDEMPOTENT_ID: DBColumn;
    static readonly COLUMN_SENDER: DBColumn;
    static readonly COLUMN_SENDER_SEC: DBColumn;
    static readonly COLUMN_CREATE_TIME: DBColumn;
    static readonly COLUMN_VALUE: DBColumn;
    static readonly COLUMN_DELETED: DBColumn;
    static readonly COLUMN_VERSION: DBColumn;
    static readonly COLUMN_STATUS: DBColumn;
    static readonly COLUMN_LIST: DBColumn[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

import { DBFtsColumn } from './DBColumn';
export declare class FTSSearchGroupConfig {
    static readonly TABLE_NAME = "fts_group_index_table";
    static readonly COLUMN_GROUP_NAME: DBFtsColumn;
    static readonly COLUMN_LIST: DBFtsColumn[];
    static getCreator(): string;
    static getIndexCreator(): string[];
}

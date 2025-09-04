import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare class DaoUtils {
    /**
     * 辅助进行批量查询时，将同数据库批量操作合并同类项
     * @param msgUuidMap
     * @returns
     */
    static groupMsgUuidMap(obj: IMSdkBaseObject, msgUuidMap: Map<string, string>): Map<number, string[]>;
    static splitSqlInParams<T>(paramList: T[], limit?: number): T[][];
    static inSqlString(items: string[]): string;
    static inSqlNumber(items: number[]): string;
}

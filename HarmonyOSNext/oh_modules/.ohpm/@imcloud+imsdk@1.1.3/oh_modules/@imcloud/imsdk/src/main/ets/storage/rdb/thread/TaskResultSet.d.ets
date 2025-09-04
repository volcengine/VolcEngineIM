import collections from "@arkts.collections";
import { ValueType as ValueType } from "@ohos.data.ValuesBucket";
@Sendable
export declare class TaskResultSet {
    columnCount: number;
    rowCount: number;
    columnNames: collections.Array<string>;
    columnIndexMap: collections.Map<string, number>;
    indexColumnMap: collections.Map<number, string>;
    data: collections.Array<collections.Map<number, ValueType | collections.Uint8Array | undefined>>;
    curRowData: collections.Map<number, ValueType | collections.Uint8Array | undefined>;
    rowIndex: number;
    exception: string | undefined;
    getColumnIndex(columnName: string): number;
    getColumnName(columnIndex: number): string;
    goToFirstRow(): boolean;
    goToNextRow(): boolean;
    getLong(columnIndex: number): number;
    getString(columnIndex: number): string;
    getBlob(columnIndex: number): Uint8Array | undefined;
    setException(e: object): void;
}
@Sendable
export declare class TaskBResult {
    exception: string;
    isSuccess: boolean;
    rowCount: number;
    setException(e: object): void;
}

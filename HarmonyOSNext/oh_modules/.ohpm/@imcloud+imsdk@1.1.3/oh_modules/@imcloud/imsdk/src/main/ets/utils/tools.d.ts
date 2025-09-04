import Long from 'long';
export declare function chunkArray<T>(arr: T[], size: number): T[][];
export declare function groupBy<T>(arr: T[], func: (val: T) => string): {
    [k: string]: T[];
};
export declare function groupArr<T>(arr: T[], subArrLen: number): T[][];
export declare function combineToArray<T>(value?: T | T[], defaultValue?: T): T[];
/**
 * @deprecated(message="此方法比较晦涩难懂，建议废弃", replaceWith=string2Long)
 * @param str
 * @returns
 */
export declare function string2LongAsBit(str: string): Long;
export declare function string2Long(val: string, defaultValue?: Long): Long;
export declare function string2Number(val: string, defaultValue?: number): number;
export declare function diffArray<T>(currentArray: T[], newArray: T[]): {
    added: T[];
    removed: T[];
};
export declare function isTrueValue(ext?: Map<string, string>, key?: string): boolean;
export declare function isNotEmpty(str?: string | undefined | any): boolean;
export declare function isEmpty(str?: string | undefined | any): boolean;
export declare function random(min: number, max: number): number;
export declare function sleep(sleepTime: number): Promise<void>;
export declare function long2Bigint(val: Long | undefined): bigint;
export declare function long2Number(val: Long | undefined): number;
/**
 * TODO 确认一下各个接口的默认值
 * @param val
 * @param defaultValue
 * @returns
 */
export declare function bigint2Long(val: bigint | undefined): Long;
export declare function bigint2LongNullable(val: bigint | undefined, defaultValue?: Long | undefined): Long | undefined;
export declare function bigintFromString(val: string | undefined): bigint;
export declare function hashCode(s: string): number;
export declare function max<T>(...values: T[]): T;
export declare function min<T>(...values: T[]): T;
export declare function abs(value: bigint | number): number | bigint;

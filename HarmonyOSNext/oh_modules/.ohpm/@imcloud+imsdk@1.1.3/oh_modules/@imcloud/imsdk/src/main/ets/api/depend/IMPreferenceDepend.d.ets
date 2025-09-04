export interface IMPreferenceDepend {
    init(context: Context, prefFileName: string): Promise<void>;
    clear(): Promise<void>;
    getString(key: string, defValue: string): Promise<string>;
    getNumber(key: string, defValue: number): Promise<number>;
    getBigInt(key: string, defValue: bigint): Promise<bigint>;
    getBoolean(key: string, defValue: boolean): Promise<boolean>;
    putString(key: string, value: string): Promise<void>;
    putNumber(key: string, value: number): Promise<void>;
    putBigint(key: string, value: bigint): Promise<void>;
    putBoolean(key: string, value: boolean): Promise<void>;
    getStringArr(key: string, defValue: string[]): Promise<string[]>;
    putStringArr(key: string, value: string[]): Promise<void>;
}

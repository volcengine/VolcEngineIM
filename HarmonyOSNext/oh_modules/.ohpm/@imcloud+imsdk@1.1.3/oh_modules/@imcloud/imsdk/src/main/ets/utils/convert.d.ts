import Long from 'long';
export declare class ConvertUtil {
    /**
     * 使用方法：Object.entries(JSON.parse(str, ConvertUtil.reviverToString)))
     * @param key
     * @param value
     * @returns
     */
    static reviverToString(key: ESObject, value: ESObject): ESObject;
    static convertMap(map: Map<string, string>): ({
        [k: string]: string;
    });
    static convertMapGenerics<T>(map: Map<string, T>): ({
        [k: string]: T;
    });
    static convertObj(obj: {
        [k: string]: string;
    }, intoMap?: Map<string, string>): Map<string, string>;
    static convertObjectT<T>(obj: {
        [k: string]: T;
    }): Map<string, T>;
    static longFromString(str: string): Long;
    static mergeMap(...maps: Map<string, string>[]): Map<string, string>;
    static longToNumber(l: Long | any | undefined): number;
    static assertLongToNumber(l: Long | any | undefined): number;
    /**
     * 将Map数据结构转为string的方法，已验证有效
     * @param sourceMap
     * @returns
     */
    static convertMapToJsonString<K, V>(sourceMap: Map<K, V>): string;
    /**
     * 用于pb接口定义的类型
     * 给定对象，输出json字符串
     * @param obj
     * @returns
     */
    static convertObjToJsonStr(obj: ESObject): string;
    /**
     * 用于pb接口定义的类型
     * 给定json字符串，输出对象
     * @param type
     * @param jsonStr
     * @returns
     */
    static convertJsonStrToObj<R>(type: ESObject, jsonStr: string): R;
    static store64BitsDataIntoHarmony(bits64Data: bigint | Long | string): string;
    static loadBigIntValueFromHarmony(stringValue: string | number): bigint;
    static parseJSONBig<T>(content: string): T;
    static convertObjectLong<T>(obj: {
        [k: string]: Long;
    }): Map<bigint, bigint>;
    static convertInt64Map(obj: {
        [k: string]: Long;
    }): Map<string, Long>;
}

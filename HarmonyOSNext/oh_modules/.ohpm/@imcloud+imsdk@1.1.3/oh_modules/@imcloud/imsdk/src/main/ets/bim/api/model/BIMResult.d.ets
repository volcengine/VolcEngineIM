import { BIMErrorCode } from '../enum/BIMErrorCode';
/**
 * @detail keytype
 * @brief 结果信息。
 */
export declare class BIMResult<T> {
    /**
     * @hidden
     */
    private _code;
    /**
     * @return 错误码
     * @detail api
     * @brief 错误码信息
     */
    get code(): BIMErrorCode;
    /**
     * @hidden
     */
    private _data;
    /**
     * @return data
     * @detail api
     * @brief data信息
     */
    get data(): T;
    /**
     * @hidden
     */
    constructor(code: BIMErrorCode, t: T);
}

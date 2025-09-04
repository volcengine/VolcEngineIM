import { ErrorType } from './consts';
/** @internal */
export interface RequestErrorParams {
    type: ErrorType;
    message: string;
    innerError?: Error;
    reachServer?: boolean;
    allowRetry?: boolean;
    ignoreEvent?: boolean;
    args?: {
        [k: string]: any;
    };
    logid?: string;
}
/** 基本错误类型 */
export declare class RequestError extends Error implements RequestErrorParams {
    type: ErrorType;
    message: string;
    innerError?: Error;
    reachServer?: boolean;
    allowRetry?: boolean;
    ignoreEvent?: boolean;
    args?: {
        [k: string]: any;
    };
    logid?: string;
    constructor(param: RequestErrorParams);
    toString(): string;
}
export interface SDKErrorParams {
    msg: string;
    innerError?: Error;
}
export declare class SDKError extends Error implements SDKErrorParams {
    msg: string;
    innerError?: Error;
    constructor(param: SDKErrorParams);
    toString(): string;
}

import { IIMLogDepend } from '../api/depend/IIMLogDepend';
import { IMSdkContext } from '../client/IMSdkContext';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare enum LoggerLevel {
    debug = "debug",
    info = "info",
    warn = "warn",
    error = "error",
    none = "none"
}
export declare class IMDefaultLogger extends IMSdkBaseObject implements IIMLogDepend {
    constructor(context: IMSdkContext);
    debug(...args: string[]): void;
    info(...args: string[]): void;
    warn(...args: string[]): void;
    error(...args: string[]): void;
    log(level: LoggerLevel, ...args: string[]): void;
    private appendTraceIfNeeded;
}

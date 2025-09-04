export declare enum LoggerLevel {
    debug = "debug",
    info = "info",
    warn = "warn",
    error = "error",
    none = "none"
}
export declare class Logger {
    static level: LoggerLevel;
    private static log;
    static debug(...m9: string[]): void;
    static info(...l9: string[]): void;
    static warn(...k9: string[]): void;
    static error(...j9: string[]): void;
}

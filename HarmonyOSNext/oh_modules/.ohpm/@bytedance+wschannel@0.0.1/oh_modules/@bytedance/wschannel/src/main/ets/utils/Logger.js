export var LoggerLevel;
(function (p9) {
    p9["debug"] = "debug";
    p9["info"] = "info";
    p9["warn"] = "warn";
    p9["error"] = "error";
    p9["none"] = "none";
})(LoggerLevel || (LoggerLevel = {}));
export class Logger {
    static log(n9, ...o9) {
        console.log(`[WS_LOG] [${n9}]:`, ...o9);
    }
    static debug(...m9) {
        Logger.log(LoggerLevel.debug, ...m9);
    }
    static info(...l9) {
        Logger.log(LoggerLevel.info, ...l9);
    }
    static warn(...k9) {
        Logger.log(LoggerLevel.warn, ...k9);
    }
    static error(...j9) {
        Logger.log(LoggerLevel.error, ...j9);
    }
}
Logger.level = LoggerLevel.debug;

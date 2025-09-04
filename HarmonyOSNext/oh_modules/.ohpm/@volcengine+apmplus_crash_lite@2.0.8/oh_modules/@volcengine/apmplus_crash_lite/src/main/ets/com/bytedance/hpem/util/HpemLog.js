import hilog from '@ohos.hilog';
const DOMAIN = 0x001c;
const TAG = '[Apm]';
const SYMBOL = ' --> ';
export class HpemLog {
    static debug(j18, k18, ...l18) {
        if (HpemLog.isLoggable(j18, hilog.LogLevel.DEBUG)) {
            hilog.debug(DOMAIN, TAG, j18 + SYMBOL + k18, l18);
        }
    }
    static info(g18, h18, ...i18) {
        if (HpemLog.isLoggable(g18, hilog.LogLevel.INFO)) {
            hilog.info(DOMAIN, TAG, g18 + SYMBOL + h18, i18);
        }
    }
    static warn(d18, e18, ...f18) {
        if (HpemLog.isLoggable(d18, hilog.LogLevel.WARN)) {
            hilog.warn(DOMAIN, TAG, d18 + SYMBOL + e18, f18);
        }
    }
    static error(a18, b18, ...c18) {
        if (HpemLog.isLoggable(a18, hilog.LogLevel.ERROR)) {
            hilog.error(DOMAIN, TAG, a18 + SYMBOL + b18, c18);
        }
    }
    static fatal(x17, y17, ...z17) {
        if (HpemLog.isLoggable(x17, hilog.LogLevel.FATAL)) {
            hilog.fatal(DOMAIN, TAG, x17 + SYMBOL + y17, z17);
        }
    }
    static isLoggable(v17, w17) {
        if (HpemLog.debugMode) {
            return true;
        }
        return false;
    }
    static setDebugMode(u17) {
        HpemLog.debugMode = u17;
    }
}
HpemLog.debugMode = false;

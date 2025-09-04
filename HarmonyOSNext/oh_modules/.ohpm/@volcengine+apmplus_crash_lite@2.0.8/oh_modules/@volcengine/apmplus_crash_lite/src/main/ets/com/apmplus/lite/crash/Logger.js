export class Logger {
    static log(q3) {
        if (Logger.LOG_ENABLE) {
            console.log(Logger.TAG + q3);
        }
    }
    static error(o3, p3) {
        if (Logger.LOG_ENABLE) {
            console.error(Logger.TAG + o3, p3);
        }
    }
}
Logger.TAG = 'apmlite ';
Logger.LOG_ENABLE = false;

/**
 * Basic log class
 */
export declare class HpemLog {
    /**
     * Outputs debug-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     *
     */
    private static debugMode;
    static debug(j18: string, k18: string, ...l18: [
    ]): void;
    /**
     * Outputs info-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static info(g18: string, h18: string, ...i18: [
    ]): void;
    /**
     * Outputs warning-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static warn(d18: string, e18: string, ...f18: [
    ]): void;
    /**
     * Outputs error-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static error(a18: string, b18: string, ...c18: [
    ]): void;
    /**
     * Outputs fatal-level logs.
     *
     * @param tag Identifies the log tag.
     * @param format Indicates the log format string.
     * @param args Indicates the log parameters.
     * @since 7
     */
    static fatal(x17: string, y17: string, ...z17: [
    ]): void;
    /**
     * Checks whether logs of the specified tag, and level can be printed.
     *
     * @param tag Identifies the log tag.
     * @param level log level
     * @since 7
     */
    private static isLoggable;
    static setDebugMode(u17: boolean): void;
}

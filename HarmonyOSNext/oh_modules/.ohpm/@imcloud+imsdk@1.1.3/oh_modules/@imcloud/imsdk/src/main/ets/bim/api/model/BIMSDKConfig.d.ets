/**
 * @detail keytype
 * @brief SDK 初始化配置信息，包含日志打印配置
 */
export declare class BIMSDKConfig {
    /**
     * @hidden
     * @brief 是否开启AppLog，默认开启，建议开启辅助问题排查，慎重关闭，否则无法支持线上问题排查。
     */
    isEnableAPM: boolean;
    /**
     * @hidden
     * @brief 是否开启性能监控，默认开启，建议开启辅助问题排查，慎重关闭，否则无法支持线上问题排查。
     */
    isEnableAppLog: boolean;
    /**
     * @brief 设置日志监听。
     */
    listener: BIMLogListener;
}
export declare type BIMLogListener = (v: BIMLogLevel, content: string) => void;
/**
 * @detail keytype
 * @brief 输出的日志级别。
 */
export declare enum BIMLogLevel {
    /**
     * @brief debug
     */
    BIM_LOG_DEBUG = 1,
    /**
     * @brief info
     */
    BIM_LOG_INFO = 2,
    /**
     * @brief warn
     */
    BIM_LOG_WARN = 3,
    /**
     * @brief error
     */
    BIM_LOG_ERROR = 4
}

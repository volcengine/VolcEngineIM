import { IMEnvService, IMLogService, IMNetService, IMUploaderService, IMWSService } from '@imcloud/imsdk_common';
export declare class IMLoader {
    /**
     * 创建环境服务实例
     * @param isTob
     * @returns
     */
    static createEnvService(): Promise<IMEnvService | undefined>;
    /**
     * 创建网络服务实例
     * @param isTob
     * @returns
     */
    static createNetService(): Promise<IMNetService | undefined>;
    /**
     * 创建长连接服务实例
     * @param isTob
     * @returns
     */
    static createWSService(): Promise<IMWSService | undefined>;
    /**
     * 创建上传实例
     * @param isTob
     * @returns
     */
    static createUploadService(): Promise<IMUploaderService | undefined>;
    /**
     * 创建日志实例
     * @param isTob
     * @returns
     */
    static createLogService(): Promise<IMLogService | undefined>;
    /**
     * 动态加载
     * @param harName
     * @param className
     * @returns
     */
    private static loadService;
}

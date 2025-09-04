export interface IIMHostEnvDepend {
    /**
     * 是否是主进程
     * @returns
     */
    isMainProcess(): boolean;
    /**
     * 获取当前服务器时间
     * @returns
     */
    getCurrentServerTime(): number;
    /***
     * @see Android抖音的SDKBridge#getDeltaTimeFromServer
     */
    getDeltaTimeFromServer(): number;
    /**
     * 当前用户是否为新用户
     * @returns
     */
    isNewUser(): boolean;
}

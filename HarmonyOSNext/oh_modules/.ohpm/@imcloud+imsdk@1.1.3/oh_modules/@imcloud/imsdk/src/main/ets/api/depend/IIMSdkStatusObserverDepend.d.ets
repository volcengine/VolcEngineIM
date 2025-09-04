/**
 * IMSDK内部的一些关键节点的状态监听
 */
export interface IIMSdkStatusObserverDepend {
    /**
     * im client登录完成回调
     */
    onIMClientLogin(): void;
    /**
     * im client 初始化结果回调
     * @param inbox
     * @param result
     */
    onIMInitResult(inbox: number, result: number): void;
}

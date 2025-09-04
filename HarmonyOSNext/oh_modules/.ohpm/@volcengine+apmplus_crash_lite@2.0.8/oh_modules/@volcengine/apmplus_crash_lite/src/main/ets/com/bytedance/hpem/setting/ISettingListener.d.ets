/**
 * @wangtao
 * @date 2024/3/6
 * 配置更新回调
 */
export interface ISettingListener {
    /**
     * 配置更新的回调
     * @param result 配置
     * @param fromLocal 是否从本地读取的配置
     */
    onRefresh: (result: string, fromLocal: boolean) => void;
    /**
     * 首次配置获取完成的回调
     */
    onReady: () => void;
}

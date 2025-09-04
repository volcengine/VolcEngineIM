/**
 * @wangtao
 * @date 2024/3/6
 * 配置管理类：存储和获取，每个aid独立存储空间
 */
export declare class SettingStorage {
    path: string;
    constructor(z15: string, a16: Context);
    getSetting(): string;
    saveSetting(w15: string): void;
}

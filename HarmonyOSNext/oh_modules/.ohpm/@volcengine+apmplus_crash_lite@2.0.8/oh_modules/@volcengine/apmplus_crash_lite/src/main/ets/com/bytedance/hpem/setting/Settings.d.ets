/**
 * @wangtao
 * @date 2024/3/6
 * 配置管理类：注册和通知/定时器管理
 */
import { ArrayList } from '@kit.ArkTS';
import { SettingStorage } from './SettingStorage';
import { ISettingListener } from './ISettingListener';
import { SettingParam } from './net/SettingParam';
export declare class Settings {
    static TAG: string;
    static minInterval: number;
    aid: string;
    token: string;
    commonParam: SettingParam;
    url: string;
    intervalId: number;
    interval: number;
    storage: SettingStorage | undefined;
    currentSetting: string;
    list: ArrayList<ISettingListener>;
    ready: boolean;
    settingFromLocal: boolean;
    hasInterval: boolean;
    constructor(r15: string, s15: string, t15: string, u15: SettingParam, v15: Context);
    beginUpdate(): void;
    startInterval(): void;
    requestSetting(): void;
    getBody(): Array<object>;
    /**
     * 从本地获取缓存setting
     */
    updateFromLocal(): void;
    saveToLocal(g15: string): void;
    updateCurrentSetting(e15: string, f15: boolean): void;
    notifyListener(b15: string): void;
    /**
     * 设置配置请求间隔，单位毫秒
     * @param interval
     */
    setUpdateInterval(a15: number): void;
    registerListener(z14: ISettingListener): void;
    removeListener(y14: ISettingListener): void;
    stopUpdate(): void;
}

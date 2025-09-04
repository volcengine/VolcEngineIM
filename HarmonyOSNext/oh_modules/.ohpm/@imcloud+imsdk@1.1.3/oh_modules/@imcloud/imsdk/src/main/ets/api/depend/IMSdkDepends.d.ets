import { IIMNetworkDepend } from './IIMNetworkDepend';
import { IIMLogDepend } from './IIMLogDepend';
import { IIMMonitorDepend } from './IIMMonitorDepend';
import { IIMHostEnvDepend } from './IIMHostEnvDepend';
import { IIMSdkStatusObserverDepend } from './IIMSdkStatusObserverDepend';
import { IIMCalculatorDepend } from './IIMCalculatorDepend';
import { IIMExtendMsgHandlerDepend } from './IIMExtendMsgHandlerDepend';
import { IIMSearchDepend } from './IIMSearchDepend';
import { IMPreferenceDepend } from './IMPreferenceDepend';
import { BIMClient } from '../../bim/api/BIMClient';
/**
 * IMSDK依赖外部注入的能力
 */
export interface IIMSdkDepend {
    /**
     * 网络依赖
     */
    netWorkDepend: IIMNetworkDepend;
    /**
     * 日志能力依赖，可选注入，不注入则默认打到console中
     */
    logDepend?: IIMLogDepend;
    /**
     * 埋点监控依赖
     */
    monitorDepend: IIMMonitorDepend;
    /**
     * 宿主的一些环境信息依赖，如是否主进程、是否debug模式等
     */
    hostEnvDepend: IIMHostEnvDepend;
    /**
     * 提供给外部监听sdk内部的一些关键节点的状态信息的接口
     */
    sdkStatusObserverDepend?: IIMSdkStatusObserverDepend;
    /**
     * 依赖宿主进行一些计算逻辑的能力注入
     */
    calculatorDepend: IIMCalculatorDepend;
    /**
     * 扩展的消息处理工具
     */
    extendMsgHandler: IIMExtendMsgHandlerDepend;
    /**
     * 搜索相关注入
     */
    searchDepend: IIMSearchDepend;
    /**
     * 首选项注入
     */
    preferenceDepend: IMPreferenceDepend;
    bimClient: BIMClient;
}

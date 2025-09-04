import { IIMCalculatorDepend } from '../../api/depend/IIMCalculatorDepend';
import { IIMExtendMsgHandlerDepend } from '../../api/depend/IIMExtendMsgHandlerDepend';
import { IIMHostEnvDepend } from '../../api/depend/IIMHostEnvDepend';
import { IIMLogDepend } from '../../api/depend/IIMLogDepend';
import { IIMMonitorDepend } from '../../api/depend/IIMMonitorDepend';
import { IIMNetworkDepend } from '../../api/depend/IIMNetworkDepend';
import { IIMSdkStatusObserverDepend } from '../../api/depend/IIMSdkStatusObserverDepend';
import { IIMSearchDepend } from '../../api/depend/IIMSearchDepend';
import { IMPreferenceDepend } from '../../api/depend/IMPreferenceDepend';
import { IIMSdkDepend } from '../../api/depend/IMSdkDepends';
import { BIMClient } from '../api/BIMClient';
export declare class BIMDepend implements IIMSdkDepend {
    netWorkDepend: IIMNetworkDepend;
    logDepend?: IIMLogDepend | undefined;
    monitorDepend: IIMMonitorDepend;
    hostEnvDepend: IIMHostEnvDepend;
    sdkStatusObserverDepend?: IIMSdkStatusObserverDepend | undefined;
    calculatorDepend: IIMCalculatorDepend;
    extendMsgHandler: IIMExtendMsgHandlerDepend;
    searchDepend: IIMSearchDepend;
    preferenceDepend: IMPreferenceDepend;
    bimClient: BIMClient;
    constructor(netWorkDepend: IIMNetworkDepend, logDepend: IIMLogDepend | undefined, monitorDepend: IIMMonitorDepend, hostEnvDepend: IIMHostEnvDepend, sdkStatusObserverDepend: IIMSdkStatusObserverDepend | undefined, calculatorDepend: IIMCalculatorDepend, extendMsgHandler: IIMExtendMsgHandlerDepend, searchDepend: IIMSearchDepend, preferenceDepend: IMPreferenceDepend, bimClient: BIMClient);
}

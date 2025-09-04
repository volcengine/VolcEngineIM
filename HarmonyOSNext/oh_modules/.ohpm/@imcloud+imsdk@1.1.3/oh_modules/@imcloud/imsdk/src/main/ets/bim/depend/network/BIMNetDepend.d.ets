import { IMAccessor } from '@imcloud/imsdk_common';
import { IIMNetworkDepend, IIMSdkHttpDepend, IIMSdkWsDepend } from '../../../api/depend/IIMNetworkDepend';
export declare class BIMNetWorkDepend implements IIMNetworkDepend {
    wsDepend: IIMSdkWsDepend;
    httpDepend: IIMSdkHttpDepend;
    imAccessor: IMAccessor;
    constructor(httpDep: IIMSdkHttpDepend, wsDep: IIMSdkWsDepend, imAccessor: IMAccessor);
    isNetAvailable(): boolean;
}

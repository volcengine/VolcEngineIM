import { IMSdkWsDataReceiveListener } from '@imcloud/imsdk/../../Index';
import { RequestItem } from '@imcloud/imsdk/ets/request/RequestItem';
import { IIMSdkWsDepend } from '../../../api/depend/IIMNetworkDepend';
import { IMEnvService, IMWSService } from '@imcloud/imsdk_common';
export declare class BIMWSDepend implements IIMSdkWsDepend {
    private wsService;
    private envService;
    private receiveListener;
    constructor(wsService: IMWSService, env: IMEnvService);
    init(): void;
    dispose(): void;
    setWsDataReceiveListener(listener: IMSdkWsDataReceiveListener): void;
    send(item: RequestItem): void;
    isWsConnect(): boolean;
}

import { IMNetService } from '@imcloud/imsdk_common/src/main/ets/api/net/IMNetService';
import { IIMSdkHttpDepend } from '../../../api/depend/IIMNetworkDepend';
import { im_proto } from '../../../api/proto';
import { RequestItem } from '../../../request/RequestItem';
import { IMEnvService, IMLogService } from '@imcloud/imsdk_common';
export declare class BIMHttpDepend implements IIMSdkHttpDepend {
    private tag;
    private netService;
    private logger;
    private envService;
    constructor(netService: IMNetService, logger: IMLogService, env: IMEnvService);
    sendRequest(item: RequestItem): Promise<im_proto.Response>;
    protected encode(request: im_proto.Request): ArrayBuffer;
    protected decode(data: ArrayBuffer): im_proto.Response;
    private getHttpRequestTag;
}

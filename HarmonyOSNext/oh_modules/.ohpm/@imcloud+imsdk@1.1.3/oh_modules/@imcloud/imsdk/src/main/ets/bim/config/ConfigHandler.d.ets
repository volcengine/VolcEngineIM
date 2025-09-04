import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
import { IMSdkContext } from '../../client/IMSdkContext';
export declare class ConfigHandler extends IMBaseHandler {
    private readonly TAG;
    constructor(context: IMSdkContext);
    /**
     * 更新config配置
     */
    getConfig(): Promise<string>;
    getConfigFromServer(): Promise<string>;
    protected forceHttp(): boolean;
}

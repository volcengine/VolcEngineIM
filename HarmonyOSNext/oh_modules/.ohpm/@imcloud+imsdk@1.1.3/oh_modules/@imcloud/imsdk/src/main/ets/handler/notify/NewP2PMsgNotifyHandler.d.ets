import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class NewP2PMsgNotifyHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    handleResponse(item: RequestItem): Promise<void>;
}

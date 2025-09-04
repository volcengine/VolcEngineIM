import { RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class NewLiveMsgNotifyHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    handleResponse(item: RequestItem): void;
}

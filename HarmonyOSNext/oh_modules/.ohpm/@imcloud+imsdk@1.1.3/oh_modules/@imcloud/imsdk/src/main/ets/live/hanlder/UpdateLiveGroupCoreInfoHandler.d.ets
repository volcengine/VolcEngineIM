import { BIMResult, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class UpdateLiveGroupCoreInfoHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    updateName(conversationShortId: string, name: string): Promise<BIMResult<boolean>>;
    updateDesc(conversationShortId: string, desc: string): Promise<BIMResult<boolean>>;
    updateIcon(conversationShortId: string, icon: string): Promise<BIMResult<boolean>>;
    updateNotice(conversationShortId: string, notice: string): Promise<BIMResult<boolean>>;
}

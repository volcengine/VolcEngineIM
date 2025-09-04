import { IMResult } from '../../api/bean/IMHandlerResult';
import { RequestError } from '../../api/const/error';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { UpdateGroupParams } from '../params/UpdateGroupParams';
/**
 * 更新群信息
 */
export declare class UpdateGroupHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    update(params: UpdateGroupParams): Promise<IMResult<boolean>>;
    protected handleResponse(item: RequestItem, params: UpdateGroupParams): Promise<Nullable<boolean>>;
    protected handleError(e: RequestError): void;
}

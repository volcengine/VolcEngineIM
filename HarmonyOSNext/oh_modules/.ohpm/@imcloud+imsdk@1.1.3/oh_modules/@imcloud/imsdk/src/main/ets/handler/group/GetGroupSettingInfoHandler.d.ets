import { IMResult } from '../../api/bean/IMHandlerResult';
import { RequestError } from '../../api/const/error';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { GetGroupSettingInfoParams } from '../params/GetGroupSettingInfoParams';
/***
 * 获取群设置信息
 */
export declare class GetGroupSettingInfoHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    get(params: GetGroupSettingInfoParams): Promise<IMResult<im_proto.IGetGroupManagerInfoResponseBody>>;
    protected handleResponse(item: RequestItem, params: GetGroupSettingInfoParams): Promise<Nullable<im_proto.IGetGroupManagerInfoResponseBody>>;
    isSuccess(item: RequestItem): boolean;
    protected handleError(e: RequestError): void;
}

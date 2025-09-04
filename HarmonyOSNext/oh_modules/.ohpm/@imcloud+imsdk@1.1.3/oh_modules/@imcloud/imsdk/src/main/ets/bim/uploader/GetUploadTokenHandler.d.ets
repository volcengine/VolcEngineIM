import { IMUploadTokenInfo } from '@imcloud/imsdk_common';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
import { IMSdkContext } from '../../client/IMSdkContext';
import { im_proto } from '../../api/proto';
import { RequestItem } from '../../request/RequestItem';
export declare class GetUploadTokenHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    getToken(tokenType: im_proto.MediaTokenType): Promise<IMUploadTokenInfo | undefined>;
    protected isSuccess(item: RequestItem): boolean;
    getVideoToken(): void;
    protected forceHttp(): boolean;
}

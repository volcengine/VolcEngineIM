import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { Attachment } from '../../api/model/Attachment';
export declare class GetMediaUrlHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    getImageUrl(attachment: Attachment): Promise<Nullable<im_proto.IGetMediaUrlsResponseBody>>;
    getFileUrl(attachment: Attachment): Promise<Nullable<im_proto.IGetMediaUrlsResponseBody>>;
    getVideoUrl(attachment: Attachment): Promise<Nullable<im_proto.IGetMediaUrlsResponseBody>>;
    getAudioUrl(attachment: Attachment): Promise<Nullable<im_proto.IGetMediaUrlsResponseBody>>;
    protected forceHttp(): boolean;
}

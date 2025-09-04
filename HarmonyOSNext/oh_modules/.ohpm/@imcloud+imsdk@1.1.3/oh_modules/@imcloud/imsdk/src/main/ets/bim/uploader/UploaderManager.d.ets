import { IMLogService } from '@imcloud/imsdk_common';
import { BIMMessage } from '../api/model/BIMMessage';
import { IMSdkClient } from '../../client/IMSdkClient';
import { im_proto } from '../../api/proto';
import { BIMClient } from '../api/BIMClient';
export declare class UploaderManager {
    private tag;
    private uploaderSerialHelper;
    private imageToken;
    private videoToken;
    private _innerSdk;
    private _uploadService;
    logger: IMLogService;
    constructor(context: Context, innerSdk: IMSdkClient, bimClient: BIMClient);
    uploadMsgSerial(msg: BIMMessage, listener: UploadListener): void;
    uploadMediaMessage(bimMessage: BIMMessage, listener: UploadListener): Promise<void>;
    private uploadWithImage;
    private uploadWithVideo;
    private saveMessage;
    failedMessage(bimMessage: BIMMessage, listener: UploadListener | undefined): Promise<void>;
    private refreshToken;
    static getImageUrl(imgOptions: im_proto.IImgOption[], index: number): string;
}
export interface UploadListener {
    onStart: (message: BIMMessage) => void;
    onProgress: (message: BIMMessage, progress: number) => void;
    onSuccess: (message: BIMMessage) => void;
    onFailed: (message: BIMMessage) => void;
}

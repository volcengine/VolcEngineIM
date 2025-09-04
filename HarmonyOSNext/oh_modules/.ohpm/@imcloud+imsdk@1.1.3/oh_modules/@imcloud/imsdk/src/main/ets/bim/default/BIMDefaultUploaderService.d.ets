import { IMAccessor, IMImageUploadResult, IMUploaderService, IMUploadListener, IMUploadTokenInfo, IMVideoUploadResult } from '@imcloud/imsdk_common';
export declare class BIMDefaultUploaderService extends IMUploaderService {
    onConfigReady(json: string): void;
    init(context: Context, imAccessor: IMAccessor): void;
    unInit(context: Context): void;
    onLogin(context: Context, uid: bigint): void;
    onLogout(): void;
    uploadImage(path: string, type: number, isEncrpty: boolean, tokenInfo: IMUploadTokenInfo, listener: IMUploadListener<IMImageUploadResult>): void;
    uploadVideo(path: string, type: number, isEncrpty: Boolean, tokenInfo: IMUploadTokenInfo, listener: IMUploadListener<IMVideoUploadResult>): void;
}

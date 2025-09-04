import uri from "@ohos.uri";
export declare class Attachment {
    msgUuid: Nullable<string>;
    localPath: Nullable<string>;
    remoteURL: Nullable<string>;
    length: Nullable<number>;
    type: Nullable<string>;
    index: Nullable<number>;
    uploadProgress: Nullable<number>;
    ext: Record<string, Nullable<string>>;
    status: Nullable<number>;
    md5: Nullable<string>;
    displayType: Nullable<string>;
    mime: Nullable<string>;
    conversationId: Nullable<string>;
    encryptUrl: Nullable<string>;
    secretKey: Nullable<string>;
    algorithm: Nullable<string>;
    uploadUri: Nullable<uri.URI>;
    get extStr(): string;
    set extStr(str: string);
}
export declare enum UploadStatus {
    UNKNOWN = -1,
    /**
     * 正在上传
     */
    UPLOADING = 0,
    /**
     * 上传成功
     */
    UPLOAD_SUCCESS = 1,
    /**
     * 上传失败
     */
    UPLOAD_FAIL = 2,
    /**
     * 获取url成功
     */
    GET_URL_SUCCESS = 3,
    /**
     * 获取url失败
     */
    GET_URL_FAIL = 4
}
export declare class BIMAttachmentUtils {
    static genMediaKey(msgType: number): "media" | "image";
    static convertToContent(attach: Attachment, msgType: number): string;
    static convertToAttachment(uuid: string, cid: string, content: string, msgType: number): Attachment;
}

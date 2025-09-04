import { BIMMessage } from '../api/model/BIMMessage';
import { UploaderManager, UploadListener } from './UploaderManager';
export declare class UploaderSerialHelper {
    private tag;
    private queue;
    private uploadManager;
    private isRunning;
    private logger;
    constructor(uploadManager: UploaderManager);
    uploadMsgSerial(msg: BIMMessage, listener: UploadListener): void;
    private takeAndUpload;
}
export declare class SerialWrapper {
    private _bimMessage;
    get bimMessage(): BIMMessage;
    private _uploadListener;
    get uploadListener(): UploadListener;
    constructor(bimMessage: BIMMessage, uploadListener: UploadListener);
}

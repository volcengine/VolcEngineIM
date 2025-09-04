import { Message } from '../../model/Message';
export interface ISaveMsgResult {
    message?: Message;
    isNew: boolean;
    success: boolean;
    isCheckUpdated: boolean;
    isUpdateMsgProperty: boolean;
    isUpdateMsgAttachment: boolean;
}
export declare class SaveMsgResult implements ISaveMsgResult {
    message?: Message;
    isNew: boolean;
    success: boolean;
    isCheckUpdated: boolean;
    isUpdateMsgProperty: boolean;
    isUpdateMsgAttachment: boolean;
    constructor(result: ISaveMsgResult);
}

import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
export declare class InboxTypeService extends IMSdkBaseObject {
    isValidInbox(input?: number): boolean;
    needSpecifyInbox(): boolean;
    getDefaultInboxWithoutCheck(): number;
    getDefaultInbox(): number;
    getInboxTypeArray(): number[];
}

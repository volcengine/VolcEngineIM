import { im_proto } from '../../api/proto';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
export declare class NewMsgNotifyHandlerMultiInstanceExt extends IMSdkBaseObject {
    saveMessage(body: im_proto.IMessageBody, ignoredUpdateMsg: boolean, flagKV: Map<string, string>, msgSource: number): Promise<void>;
}

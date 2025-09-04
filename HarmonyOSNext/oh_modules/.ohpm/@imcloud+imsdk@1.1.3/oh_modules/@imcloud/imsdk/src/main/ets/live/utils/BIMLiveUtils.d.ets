import { BIMMember, BIMMessage, im_proto, Member } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
export declare class BIMLiveUtils {
    private TAG;
    static wrapperMember(memberList: Member[]): BIMMember[];
    static fromJson<T>(cls: T, json: string): ESObject;
    static convertList(context: IMSdkContext, bodyList: im_proto.MessageBody[] | undefined | null): BIMMessage[];
    static convert(context: IMSdkContext, body: im_proto.IMessageBody): BIMMessage;
}

import { im_proto } from '../api/proto';
import { IMSdkContext } from '../client/IMSdkContext';
import { Member } from '../api/model/Member';
export declare class MemberUtils {
    static convertMemberList(context: IMSdkContext, conversationId: Nullable<string>, items?: Nullable<im_proto.IParticipant[]>, previousMemberMap?: Map<bigint, Member>): Member[];
    static convertMember(context: IMSdkContext, conversationId: Nullable<string>, item?: Nullable<im_proto.IParticipant>): Member;
    static combineUidAndSecUid(body: im_proto.ConversationAddParticipantsResponseBody): Nullable<Map<bigint, string>>;
    static getNeedDeleteMemberList(olderMemberUidList: bigint[], newerMemberList: Member[]): bigint[];
    static absolutelyEqual(a?: Member, b?: Member): boolean;
}

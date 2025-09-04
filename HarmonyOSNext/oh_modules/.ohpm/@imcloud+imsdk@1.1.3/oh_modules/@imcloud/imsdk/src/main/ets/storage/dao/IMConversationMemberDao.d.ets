import { Member } from '../../api/model/Member';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMConversationMemberDataSource } from '../datasource/IMConversationMemberDataSource';
/**
 * IMConversationMemberDao
 * 会话表
 */
export declare class IMConversationMemberDao extends IMSdkBaseObject implements IMConversationMemberDataSource {
    private readonly dbManager;
    constructor(context: IMSdkContext);
    insertOrUpdateMembers(conversationId: Nullable<string>, conversationType: number, members: Member[]): Promise<number>;
    hasMember(cId: string, uid: string): Promise<boolean>;
    getMemberIdSet(convId: string): Promise<Nullable<Set<bigint>>>;
    getMemberIdList(convId: Nullable<string>, useThreadPool?: boolean): Promise<bigint[]>;
    getLargestOrder(convId: string): Promise<Nullable<bigint>>;
    getMembersCount(convId: Nullable<string>): Promise<Nullable<number>>;
    getMembersList(convId: Nullable<string>, uid?: Nullable<string[]>, useTheadPool?: boolean): Promise<Nullable<Member[]>>;
    getMembersMap(convId: Nullable<string>, uid?: Nullable<string[]>): Promise<Nullable<[Map<bigint, Member>, Member[]]>>;
    removeMembers(convId: string, uidList: string[]): Promise<number>;
    delete(convId: string): Promise<number>;
    /**
     * 获取群主和管理员信息
     * @returns
     */
    getGroupManagerList(convId: string): Promise<Nullable<Member[]>>;
    private buildValuesBucket;
    private buildMembersList;
    private buildMembersMap;
}

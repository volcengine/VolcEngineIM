import { Member } from '../../api/model/Member';
import { IMDataSource } from './IMDataSource';
/**
 * IMConversationMemberDataSource
 * conversation member相关的基本存储接口
 */
export interface IMConversationMemberDataSource extends IMDataSource {
    insertOrUpdateMembers(conversationId: Nullable<string>, conversationType: number, members: Member[]): Promise<number>;
    getMemberIdList(convId: Nullable<string>, useTheadPool?: boolean): Promise<bigint[]>;
    getMemberIdSet(convId: string): Promise<Nullable<Set<bigint>>>;
    getMembersMap(convId: Nullable<string>, uid?: Nullable<string[]>): Promise<Nullable<[Map<bigint, Member>, Member[]]>>;
    getMembersList(convId: Nullable<string>, uid?: Nullable<string[]>, useTheadPool?: boolean): Promise<Nullable<Member[]>>;
    getMembersCount(convId: Nullable<string>): Promise<Nullable<number>>;
    /**
     * 获取群主和管理员信息
     * @returns
     */
    getGroupManagerList(convId: string): Promise<Nullable<Member[]>>;
    /**
     * 获取会话内成员最大的sortOrder
     * @param convId
     * @returns
     */
    getLargestOrder(convId: string): Promise<Nullable<bigint>>;
    /**
     * 删除群聊成员
     * @param convId 会话id
     * @param uidList 待删除成员uid
     * @returns deletedCount
     */
    removeMembers(convId: Nullable<string>, uidList: string[]): Promise<number>;
    delete(convId: string): Promise<number>;
    hasMember(cId: string, uid: string): Promise<boolean>;
}

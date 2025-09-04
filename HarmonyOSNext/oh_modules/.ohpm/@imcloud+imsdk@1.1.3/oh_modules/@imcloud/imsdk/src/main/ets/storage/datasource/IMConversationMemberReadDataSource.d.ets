import { ParticipantIndexInfo } from '../../api/model/ParticipantIndexInfo';
import { NeedUpdateReadStateItem } from '../../model/ReadStatusModel';
import { IMDataSource } from './IMDataSource';
/**
 * IMConversationMemberDataSource
 * conversation member相关的基本存储接口
 */
export interface IMConversationMemberReadDataSource extends IMDataSource {
    /**
     * 更新或者插入会话成员的minIndex、readIndex和readOrder信息
     * @param conversationId
     * @param indexInfoMap
     * @param needUpdateReadStateItem
     * @returns
     */
    insertOrUpdateMemberRead(conversationId: string, indexInfoMap: Map<bigint, ParticipantIndexInfo>, needUpdateReadStateItem?: Nullable<NeedUpdateReadStateItem>): Promise<boolean>;
    /**
     * 将数据库中的index信息更新到MessageModel的map中
     */
    loadIndexInfoToMap(conversationId: string, indexInfoMap: Map<bigint, ParticipantIndexInfo>): Promise<Map<bigint, ParticipantIndexInfo>>;
    /**
     * 获取会话内所有成员信息
     */
    getMemberList(conversationId: string): Promise<Nullable<ParticipantIndexInfo[]>>;
    /**
     * 删除会话时，处理群成员已读状态
     * @param convId
     * @returns
     */
    delete(convId: string): Promise<boolean>;
}

import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMConversationMemberReadDataSource } from '../datasource/IMConversationMemberReadDataSource';
import { ParticipantIndexInfo } from '../../api/model/ParticipantIndexInfo';
import { NeedUpdateReadStateItem } from '../../model/ReadStatusModel';
export declare class IMConversationMemberReadDao extends IMSdkBaseObject implements IMConversationMemberReadDataSource {
    private readonly dbManager;
    constructor(context: IMSdkContext);
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
    delete(conversationId: string): Promise<boolean>;
}

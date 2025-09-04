import { Attachment } from '../../api/model/Attachment';
import { IMDataSource } from './IMDataSource';
/**
 * IMAttachmentDataSource
 * 附件相关的基本存储接口
 */
export interface IMAttachmentDataSource extends IMDataSource {
    /**
     * 根据会话id删除消息的附件
     * @param convId
     * @returns
     */
    deleteByCid(convId: string): Promise<number>;
    /**
     * 根据消息uuid删除消息附件
     * @param convId
     * @param msgUuid
     * @returns
     */
    deleteByMsgUuid(convId: string, ...msgUuid: string[]): Promise<number>;
    updateAttachments(convId: string, attachList: Attachment[]): Promise<boolean>;
    addAttachments(convId: string, attachList: Attachment[]): Promise<boolean>;
    /**
     * 批量查询消息对应的附件列表
     * @param uuidList 消息id
     * @return 附件列表
     */
    getAttachmentsMap(msgUuidList: Map<string, string>): Promise<Nullable<Map<string, Attachment[]>>>;
    /**
     * 获取消息的附件
     * @param convIs
     * @param msgUuid
     * @returns
     */
    getAttachments(convIs: string, msgUuid: string): Promise<Nullable<Attachment[]>>;
}

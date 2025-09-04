import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMAttachmentDataSource } from '../datasource/IMAttachmentDataSource';
import { Attachment } from '../../api/model/Attachment';
/**
 * IMAttachmentDao
 */
export declare class IMAttachmentDao extends IMSdkBaseObject implements IMAttachmentDataSource {
    constructor(context: IMSdkContext);
    deleteByCid(convId: string): Promise<number>;
    deleteByMsgUuid(convId: string, ...msgUuid: string[]): Promise<number>;
    addAttachments(convId: string, attachmentList: Attachment[]): Promise<boolean>;
    updateAttachments(convId: string, attachmentList: Attachment[]): Promise<boolean>;
    /**
     * 查询全部的附件
     */
    getMsgUuidMap(): Promise<Map<string, string>>;
    /**
     * 批量查询消息uuid对应的附件
     * @param msgUuidList
     * @returns
     */
    getAttachmentsMap(msgUuidList: Map<string, string>): Promise<Nullable<Map<string, Attachment[]>>>;
    /**
     * 查询单个会话单个消息uuid对应的附件
     * @param convIs
     * @param msgUuid
     * @returns
     */
    getAttachments(convIs: string, msgUuid: string): Promise<Nullable<Attachment[]>>;
    private buildAttachmentList;
    private buildValues;
}

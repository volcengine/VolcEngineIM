import { IMSdkContext } from '../../client/IMSdkContext';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { IMMsgPropertyDataSource } from '../datasource/IMMsgPropertyDataSource';
import { LocalPropertyItem } from '../../api/model/MessageProperty';
import { Message } from '../../api/model/Message';
/**
 * IMMsgDao
 * 消息表存储
 */
export declare class IMMsgPropertyDao extends IMSdkBaseObject implements IMMsgPropertyDataSource {
    constructor(context: IMSdkContext);
    deleteByCid(convId: string): Promise<number>;
    deleteByMsgUuid(convId: string, msgUuid: string): Promise<number>;
    deleteAllSync(convId: string, msgUuid: string[]): Promise<number>;
    /**
     * 查询msgUuidMap
     * @returns
     */
    getMsgUuidMap(): Promise<Map<string, string>>;
    /**
     * 查询消息的单个property
     * @param convId
     * @param msgUuid
     * @param key
     * @param idempotentId
     * @returns
     */
    getMessageProperty(convId: string, msgUuid?: string, key?: string, idempotentId?: string): Promise<Nullable<LocalPropertyItem>>;
    /**
     * 批量查询消息的properties
     * @param convId
     * @param msgUuid
     * @param key
     * @param idempotentId
     * @returns
     */
    getMessagePropertiesMap(msgUuidMap?: Map<string, string>): Promise<Nullable<Map<string, Map<string, LocalPropertyItem[]>>>>;
    /**
     * 查询消息的properties
     * @param convId
     * @param msgUuid
     * @returns
     */
    getMessageProperties(convId: string, msgUuid: string): Promise<Map<string, LocalPropertyItem[]>>;
    /**
     * 接口发出之后，DB操作更新sending状态的消息，逻辑如下：
     * 1、如果db里面没有记录，则忽略
     * 2、如果db里面有这条属性的记录，判断status
     * 如果status是changed，说明sending期间发生过修改需要再次发送，记录要修改的LocalPropertyItem，用于返回值
     * 根据success状态修改其status
     * @return 返回sending期间修改过的属性内容 LocalPropertyItem，如未修改，返回null
     */
    updateSendingProperty(convId: string, localPropertyItem: LocalPropertyItem, success: boolean): Promise<LocalPropertyItem>;
    updateMessageProperty(msg: Message): Promise<boolean>;
    /**
     * 接口发出之前，DB操作
     * @param convId
     * @param localPropertyItem
     * @returns
     */
    updatePropertySending(convId: string, localPropertyItem: LocalPropertyItem): Promise<Nullable<boolean>>;
    private buildLocalPropertyItem;
    private buildValueBucket;
}

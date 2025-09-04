import { Message } from '../../api/model/Message';
import { LocalPropertyItem } from '../../api/model/MessageProperty';
import { IMDataSource } from './IMDataSource';
/**
 * IMMsgPropertyDataSource
 * 消息Property相关的基本存储接口
 */
export interface IMMsgPropertyDataSource extends IMDataSource {
    /**
     * 删除指定会话id的消息属性
     * @param convId
     * @returns
     */
    deleteByCid(convId: string): Promise<number>;
    /**
     * 通过消息id删除指定消息属性
     * @param msgUuid
     * @returns
     */
    deleteByMsgUuid(convId: string, msgUuid: string): Promise<number>;
    /**
     * 批量删除
     * @see deleteByMsgUuid
     * @param convId
     * @param msgUuid
     * @returns
     */
    deleteAllSync(convId: string, msgUuid: string[]): Promise<number>;
    /**
     * 更新消息properties
     * @param msg
     */
    updateMessageProperty(msg: Message): Promise<boolean>;
    /**
     * 接口发出之前，DB操作更新property为发送中状态
     * @param convId
     * @param localPropertyItem
     * @returns
     */
    updatePropertySending(convId: string, localPropertyItem: LocalPropertyItem): Promise<Nullable<boolean>>;
    /**
     * 接口发出之后，DB操作更新sending状态的消息，逻辑如下：
     * 1、如果db里面没有记录，则忽略
     * 2、如果db里面有这条属性的记录，判断status
     * 如果status是changed，说明sending期间发生过修改需要再次发送，记录要修改的LocalPropertyItem，用于返回值
     * 根据success状态修改其status
     * @return 返回sending期间修改过的属性内容 LocalPropertyItem，如未修改，返回null
     */
    updateSendingProperty(convId: string, localPropertyItem: LocalPropertyItem, success: boolean): Promise<Nullable<LocalPropertyItem>>;
    /**
     * 批量查询消息的properties
     * @param convId
     * @param msgUuid
     * @param key
     * @param idempotentId
     * @returns
     */
    getMessagePropertiesMap(msgUuidMap?: Map<string, string>): Promise<Nullable<Map<string, Map<string, LocalPropertyItem[]>>>>;
}

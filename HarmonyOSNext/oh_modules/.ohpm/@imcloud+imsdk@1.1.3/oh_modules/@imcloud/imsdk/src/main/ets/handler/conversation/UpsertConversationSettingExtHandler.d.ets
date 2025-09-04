import { RequestError } from '../../api/const/error';
import { Conversation } from '../../api/model/Conversation';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/**
 * 更新会话个人维度的配置附加Ext信息
 * 相对的，还有会话全局维度的配置Ext信息
 *
 * 个人维度：仅for当前用户，偏用户属性
 * 全局维度：for会话内的所有用户、会话自身属性
 */
export declare class UpsertConversationSettingExtHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    /**
     * 覆盖更新会话个人维度的配置附加信息
     * @param convId
     * @param ext
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertSettingExtMap(convId: string, ext: Map<string, string>): Promise<Nullable<Conversation>>;
    /**
     * 更新会话个人维度的配置附加信息，只更新特定的key-value
     * @param convId
     * @param key
     * @param value
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertSettingKv(convId: string, key: string, value: string): Promise<Nullable<Conversation>>;
    handleResponse(item: RequestItem, conversation: Conversation): Promise<Nullable<Conversation>>;
    isSuccess(item: RequestItem): boolean;
    protected handleError(e: RequestError): void;
}

import { RequestError } from '../../api/const/error';
import { Conversation } from '../../api/model/Conversation';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class UpsertConversationCoreExtHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    /**
     * 更新会话全局配置的附加信息，注意会全量覆盖更新
     * 轻量的数据更新建议仅更新对应的 key-value👇
     * @see upsertCoreExtKv
     * @param convId
     * @param ext  附加信息字段，注意会全量覆盖更新。如果需要清除原来的赋值，ext的value传空字符串即可
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertCoreExtMap(convId: string, ext: Map<string, string>): Promise<Nullable<Conversation>>;
    /**
     * 更新会话个人维度的配置附加信息，只更新特定的key-value
     * @param convId
     * @param key
     * @param value
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    upsertCoreExtKv(convId: string, key: string, value: string): Promise<Nullable<Conversation>>;
    handleResponse(item: RequestItem, conversation: Conversation): Promise<Nullable<Conversation>>;
    isSuccess(item: RequestItem): boolean;
    protected handleError(e: RequestError): void;
}

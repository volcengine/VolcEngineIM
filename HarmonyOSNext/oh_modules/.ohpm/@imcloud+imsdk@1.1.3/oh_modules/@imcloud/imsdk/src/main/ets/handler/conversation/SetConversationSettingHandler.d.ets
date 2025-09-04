import { IMResult } from '../../api/bean/IMHandlerResult';
import { RequestError } from '../../api/const/error';
import { Conversation } from '../../api/model/Conversation';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/**
 * 会话设置：置顶/静音/收藏
 */
export declare class SetConversationSettingHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    /**
     * 设置会话置顶
     * @param convId
     * @param stickTop
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    changeStickTop(convId: string, stickTop: boolean): Promise<IMResult<Conversation>>;
    /**
     * 设置会话静音
     * @param convId
     * @param mute
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    changeMute(convId: string, mute: boolean): Promise<IMResult<Conversation>>;
    /**
     * 设置会收藏状态? TODO 待确认业务入口
     * @param convId
     * @param favorite
     * @returns 如果更新成功，会返回当前会话数据结构；如果失败，则返回undefined
     */
    changeFavorite(convId: string, favorite: boolean): Promise<Nullable<Conversation>>;
    /**
     * 会话settings info解析然后存储
     * @param item
     * @param conversation
     * @returns true 标识成功，否则返回undefined
     */
    handleResponse(item: RequestItem, conversation: Conversation): Promise<Nullable<boolean>>;
    isSuccess(item: RequestItem): boolean;
    protected handleError(e: RequestError): void;
}

import { IMResult } from '../../api/bean/IMHandlerResult';
import { Conversation } from '../../api/model/Conversation';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class DissolveConversationHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    /**
     * 解除会话/群聊
     * @param convId
     * @param deleteLocal true 仅标记删除；false 解散群聊
     * @param needPullConv true 如果本地没有会话则会拉取群聊会话信息
     */
    dissolve(convId: string, deleteLocal: boolean, needPullConv: boolean): Promise<IMResult<string>>;
    /**
     * 本地没有会话信息、查询接口
     * @param convId
     * @param deleteLocal
     */
    pullGroup(result: IMResult<string>, convId: string, deleteLocal: boolean): Promise<void>;
    realDissolve(result: IMResult<string>, convId: string, deleteLocal: boolean, conversation: Conversation): Promise<void>;
    private handleSuccess;
}

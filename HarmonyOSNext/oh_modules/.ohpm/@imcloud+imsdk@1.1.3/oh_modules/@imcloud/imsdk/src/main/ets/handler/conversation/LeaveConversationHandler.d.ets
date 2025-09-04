import { IMResult } from '../../api/bean/IMHandlerResult';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class LeaveConversationHandler extends IMBaseHandler {
    static _CONVERSATION_NO_EXISTS: number;
    constructor(context: IMSdkContext);
    get tag(): string;
    /**
     * 退出群聊
     * @param convId 会话id
     * @param isReqDelete 是否请求接口执行删除会话请求
     * @returns true代表操作成功
     */
    leave(convId: string, isReqDelete?: boolean): Promise<IMResult<boolean>>;
    private handleSuccess;
}

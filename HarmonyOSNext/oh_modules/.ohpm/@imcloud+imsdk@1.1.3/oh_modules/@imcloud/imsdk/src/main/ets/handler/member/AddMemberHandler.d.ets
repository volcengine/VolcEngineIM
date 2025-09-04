import { IMResult } from '../../api/bean/IMHandlerResult';
import { Member } from '../../api/model/Member';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class AddMemberHandler extends IMBaseHandler {
    get tag(): string;
    constructor(context: IMSdkContext);
    /**
     * 将用户[toAddUserIdList]加入会话群聊[convId]
     * @param convId
     * @param convShortId
     * @param toAddUserIdList
     * @param convType
     * @param inboxType
     * @param bizExtMap
     * @returns
     */
    addMember(convId: string, convShortId: bigint, toAddUserIdList: string[], convType: number, inboxType: number, bizExtMap: Map<string, string>): Promise<IMResult<Member[]>>;
    /**
     * 主动加群，处理API接口结果
     * @param convId
     * @param convShortId
     * @param item
     * @returns
     */
    private handleResponse;
    private localCreateConversation;
    isSuccess(item: RequestItem): boolean;
}

import { im_proto } from '../../api/proto/index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { RequestItem } from '../../request/RequestItem';
import { Conversation } from '../../api/model/Conversation';
import { IMResult } from '../../api/bean/IMHandlerResult';
export declare class CreateConversationHandler extends IMBaseHandler {
    constructor(imSdkContext: IMSdkContext);
    get tag(): string;
    createSingleConversation(inboxType: number, uidList: string): Promise<IMResult<Conversation>>;
    createGroupConversation(inboxType: number, uidList: string[]): Promise<IMResult<Conversation>>;
    protected forceHttp(): boolean;
    /**
     * 发起单聊时，先尝试创建临时会话
     * @param inboxType
     * @param uid 对方Uid
     */
    private buildSingleTempConversation;
    private sendCreateRequest;
    create(inboxType: number, conversationType: number, uidList: string[], uniqueId?: Nullable<string>, extMap?: Nullable<Map<string, string>>, name?: Nullable<string>, avatarUrl?: Nullable<string>, desc?: Nullable<string>, memberBeanMap?: Nullable<im_proto.IParticipantWithProperty[]>): Promise<IMResult<Conversation>>;
    protected isSuccess(item: RequestItem): boolean;
    private handleResponse;
    private processResponse;
}

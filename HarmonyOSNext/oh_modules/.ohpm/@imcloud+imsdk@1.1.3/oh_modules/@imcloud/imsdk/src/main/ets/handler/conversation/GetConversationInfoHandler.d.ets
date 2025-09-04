import { im_proto } from '../../api/proto/index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { RequestItem } from '../../request/RequestItem';
import Long from 'long';
import { RequestError } from '../../api/const/error';
import { Message } from '../../api/model/Message';
import { SaveConvResult } from '../GetUserMsgHandler';
export declare class GetConversationInfoHandler extends IMBaseHandler {
    private tempConversation;
    constructor(imSdkContext: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    /**
     * 本地会话存在，请求接口拿到最新的会话信息
     * @param convId
     * @returns
     */
    getConversationInfoByLocalExist(convId: string, force: boolean): Promise<Nullable<SaveConvResult>>;
    /**
     * 本地会话不存在，请求接口拿到最新的会话信息
     * @param inboxType
     * @param convId
     * @param convShortId
     * @param convType
     * @returns
     */
    getConversationInfoByLocalAbsent(inboxType: number, convId: string, convShortId: bigint, convType: number, force: boolean): Promise<Nullable<SaveConvResult>>;
    /**
     * 本地会话不存在，收到新的消息。请求接口拿到最新的会话信息
     * @param inboxType
     * @param message
     * @param badgeCount
     * @param filterLocalMap
     * @returns
     */
    getConversationByNewMsgReceived(inboxType: number, message: Message, badgeCount: number, force: boolean, filterLocalMap: Nullable<Map<string, string>>): Promise<Nullable<SaveConvResult>>;
    startGet(inboxType: number, convId: string, shortId: bigint, convType: number, updateTime: number, badgeCount?: Nullable<number>, force?: Nullable<boolean>, filterLocalMap?: Nullable<Map<string, string>>): Promise<SaveConvResult>;
    protected handleError(e: RequestError): void;
    private handleResponse;
    private onResponseResult;
    protected isSuccess(item: RequestItem): boolean;
    private processResponse;
    saveSingleConversation(updateTime: number, responseUid: Long, info: im_proto.ConversationInfoV2): Promise<SaveConvResult>;
    private getMembersFromResp;
}

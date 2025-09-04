import { ConversationChangeReason } from '../../../api/const/consts';
import { RequestError } from '../../../api/const/error';
import { Conversation } from '../../../api/model/Conversation';
import { im_proto } from '../../../api/proto/index';
import { IMSdkContext } from '../../../client/IMSdkContext';
import { RequestItem } from '../../../request/RequestItem';
import { IMBaseHandler } from '../../base/IMBaseHandler';
export declare class BatchUpsertConversationSettingExtHandler extends IMBaseHandler {
    _TYPE_CONV_BOX: string;
    _TYPE_FOLD_BOX: string;
    boxType: Nullable<string>;
    isRepaired: boolean;
    constructor(context: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    /**
     * 批量更新会话的个人配置ext信息
     * @param convIdList 会话id list
     * @param key
     * @param value
     * @param needPush
     * @returns 返回批量操作成功的会话集合
     */
    batchUpsertSettingExtForLabelByCid(convIdList: Nullable<string[]>, key?: Nullable<string>, value?: Nullable<string>, needPush?: Nullable<boolean>): Promise<Nullable<Conversation[]>>;
    batchUpsertSettingExtForLabel(conversationShortList: Nullable<string[]>, convList: Nullable<Conversation[]>, key?: Nullable<string>, value?: Nullable<string>, needPush?: Nullable<boolean>): Promise<Nullable<Conversation[]>>;
    /**
     *
     * @param convShortIdList 批量更新会话的ConvShortIdList
     * @param type
     * @returns 返回批量操作成功的会话集合
     */
    batchUpsertBoxSettingExt(convShortIdList: Nullable<string[]>, type: Nullable<string>): Promise<Nullable<Conversation[]>>;
    private realBatchUpsertSettingExt;
    realSendRequest(reqContentList: im_proto.UpsertConversationSettingExtInfoRequestBody[], source: number, key?: Nullable<string>, value?: Nullable<string>, needPush?: Nullable<boolean>): Promise<Nullable<[Map<string, ConversationChangeReason[]>, Conversation[]]>>;
    handleResponse(item: RequestItem): Promise<Nullable<[Map<string, ConversationChangeReason[]>, Conversation[]]>>;
    onResponseResult(failedConvShortIdList: Nullable<string[]>, result: Nullable<[Map<string, ConversationChangeReason[]>, Conversation[]]>, source: number, key: Nullable<string>, value: Nullable<string>, needPush: Nullable<boolean>): Promise<void>;
    protected isSuccess(item: RequestItem): boolean;
    protected handleError(e: RequestError): void;
}

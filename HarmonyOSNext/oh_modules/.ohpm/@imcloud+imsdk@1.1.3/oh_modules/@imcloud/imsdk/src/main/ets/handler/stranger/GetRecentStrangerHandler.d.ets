import Long from 'long';
import { RequestError } from '../../api/const/error';
import { Conversation } from '../../api/model/Conversation';
import { Message } from '../../api/model/Message';
import { im_proto } from '../../api/proto/index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class GetRecentStrangerHandler extends IMBaseHandler {
    private source;
    private loadMode;
    private pageCount;
    private conversationCount;
    private startLoadMoreVersion;
    private requestMinVersion;
    constructor(imSdkContext: IMSdkContext, source: string, loadMode?: StrangerLoadMode);
    get tag(): string;
    initLoadMoreVersion(): Promise<void>;
    protected forceHttp(): boolean;
    requestInner(maxVersion: bigint, minVersion: bigint): Promise<GetRecentStrangerMsgResult | undefined>;
    protected handleResponse(item: RequestItem): Promise<Nullable<GetRecentStrangerMsgResult>>;
    protected isSuccess(item: RequestItem): boolean;
    /**
     * 子类需要重写这个方法以实现对error的处理
     * @param e
     */
    protected handleError(e: RequestError): void;
    processResponse(body: im_proto.IGetRecentStrangerMessageRespBody, responseUid: Long): Promise<GetRecentStrangerMsgResult | undefined>;
    filterConvLocalExtFromMsg(msg: Message, outLocalExt: Map<string, string>): Promise<void>;
    updateVersion(result: GetRecentStrangerMsgResult): Promise<void>;
    onResponseResult(result?: GetRecentStrangerMsgResult): Promise<void>;
    onResponseError(item?: RequestItem): Promise<void>;
}
export declare enum StrangerLoadMode {
    REFRESH = 0,
    LOAD_MORE = 1
}
export declare class GetRecentStrangerMsgResult {
    body?: im_proto.IGetRecentStrangerMessageRespBody;
    conversations?: Conversation[];
    pageMaxVersion?: bigint;
    pageMinVersion?: bigint;
    shouldLoadMore: boolean;
    get nextVersion(): bigint;
    get hasMore(): boolean;
}

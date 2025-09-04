import Long from 'long';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestError } from '../../api/const/error';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
import { RequestItem } from '../../request/RequestItem';
import { IMError } from '../../api/bean/IMHandlerResult';
import { ConversationListModel } from '../../model/ConversationListModel';
/**
 * 操作相关Handler基类
 */
export declare class IMBaseHandler extends IMSdkBaseObject {
    protected readonly cmd: number;
    protected logId: string | undefined;
    protected uidFromResponse: Long | undefined;
    constructor(context: IMSdkContext, cmd: number);
    get tag(): string;
    /**
     * 是否强制使用http，默认false
     * @returns
     */
    protected forceHttp(): boolean;
    getWaitChecker(): import("../../helper/WaitChecker").WaitChecker;
    getConversationProcessManager(): import("../../manager/ConversationProcessManager").ConversationProcessManager;
    getMessageProcessManager(): import("../../manager/MessageProcessManager").MessageProcessManager;
    /**
     * 内部handler使用
     * @returns
     */
    getConversationListModel(): ConversationListModel;
    /**
     * 长链重试的最大次数，默认为3
     * @returns
     */
    protected getWsMaxRetryCount(): number;
    /**
     * 短链重试的最大次数，默认为2
     * @returns
     */
    protected getHttpMaxRetryCount(): number;
    /**
     * sendRequest
     *
     * async方法，子类发送请求调用
     * 返回response的promise
     * @param inboxType
     * @param requestBody
     * @returns Promise<RequestItem>
     * @throws RequestError
     */
    protected sendRequest(inboxType: number, requestBody: im_proto.RequestBody): Promise<RequestItem>;
    private sendRequestInner;
    private buildCommonRequest;
    private buildAuthInfo;
    private isUseZT;
    /**
     * 子类需要重写这个方法以实现对error的处理
     * @param e
     */
    protected handleError(e: RequestError): void;
    /**
     * 构造ErrorInfo，其中会包含业务需要的字段
     * @param requestItem
     * @returns
     */
    protected buildErrorInfo(requestItem: RequestItem): IMError;
    /**
     * 接口请求是否成功，基类默认实现
     * @param item
     * @returns
     */
    protected isSuccess(item: RequestItem): boolean;
}

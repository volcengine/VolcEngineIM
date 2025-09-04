import { im_proto } from '../api/proto';
import { RequestError } from '../api/const/error';
import { IMSdkBaseObject } from '../core/IMSdkBaseObject';
import { IMSdkContext } from '../client/IMSdkContext';
import Long from 'long';
import { IRequestItem } from '../api/bean/IRequestItem';
/**
 * 获取请求的序列号
 */
export declare class SeqIdManager extends IMSdkBaseObject {
    private seqId;
    constructor(context: IMSdkContext);
    getSeqId(): number;
}
interface WsRequestPromise {
    resolve: (item: RequestItem) => void;
    reject: (e: Error) => void;
}
/**
 * RequestItem
 */
export declare class RequestItem extends IMSdkBaseObject implements IRequestItem {
    url: string;
    path: string;
    forceHttp: boolean;
    startTime: number;
    endTime: number;
    seqId: number;
    cmd: number;
    wsPromise?: WsRequestPromise;
    request?: im_proto.Request;
    response?: im_proto.Response;
    method?: string;
    maxWsRetryTimes: number;
    maxHttpRetryTimes: number;
    wsRetryTimes: number;
    httpRetryTimes: number;
    error?: RequestError;
    errorCode: number;
    requestUidFromClient?: Long;
    ext: Nullable<string>;
    isWs: boolean;
    requestStartTime: number;
    requestEndTime: number;
    constructor(context: IMSdkContext, cmd: number, request?: im_proto.Request);
    getCode(): number;
    getFinalErrorCode(): number;
    getStatus(): number;
    getExtraInfo(): string;
    getCheckCode(): bigint;
    getCheckMsg(): string;
    getResponseLogId(): Nullable<string>;
    toString(): string;
    isSuccess(): boolean;
    isHttpRetry(): boolean;
}
export {};

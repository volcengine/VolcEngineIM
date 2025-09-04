import Long from 'long';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class CheckConversationMsgHandler extends IMBaseHandler {
    private readonly TAG;
    private startIndex;
    private minIndex;
    private hasRepairedByV2;
    constructor(context: IMSdkContext, hasRepairedByV2: boolean);
    get tag(): string;
    protected forceHttp(): boolean;
    check(convId: string, cursor: Long, totalCount: number, endCursor: Long): Promise<void>;
    handleResponse(item: RequestItem, convId: string): Promise<void>;
    protected isSuccess(item: RequestItem): boolean;
}

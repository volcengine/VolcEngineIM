import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class CheckConversationV2Handler extends IMBaseHandler {
    private localIdsMap;
    get tag(): string;
    constructor(context: IMSdkContext);
    check(inbox: number, version?: bigint, page?: number): Promise<void>;
    private getConversations;
    isSuccess(item: RequestItem): boolean;
}

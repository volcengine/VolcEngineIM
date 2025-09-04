import { RequestError } from '../../api/const/error';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class MarkAllStrangerConversationsReadHandler extends IMBaseHandler {
    inboxType: number;
    get tag(): string;
    constructor(context: IMSdkContext, inboxType: number);
    protected forceHttp(): boolean;
    markAllRead(): Promise<Nullable<boolean>>;
    handleResponse(item: RequestItem): boolean;
    protected handleError(e: RequestError): void;
}

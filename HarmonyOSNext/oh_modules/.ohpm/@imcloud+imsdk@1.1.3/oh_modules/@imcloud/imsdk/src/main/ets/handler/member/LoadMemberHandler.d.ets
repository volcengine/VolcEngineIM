import Long from 'long';
import { Conversation } from '../../api/model/Conversation';
import { Member } from '../../api/model/Member';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class LoadMemberHandler extends IMBaseHandler {
    private allMembers;
    private notify;
    constructor(context: IMSdkContext, notify?: boolean);
    get tag(): string;
    protected forceHttp(): boolean;
    load(convId: string, cursor?: Long): Promise<Member[]>;
    doLoad(convId: string, cursor?: Long): Promise<void>;
    handleResponse(item: RequestItem, conversation: Conversation): Promise<void>;
    isSuccess(item: RequestItem): boolean;
}

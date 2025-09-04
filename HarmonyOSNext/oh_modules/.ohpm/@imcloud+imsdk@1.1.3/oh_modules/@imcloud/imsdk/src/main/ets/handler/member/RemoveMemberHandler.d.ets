import { IMResult } from '../../api/bean/IMHandlerResult';
import { RequestError } from '../../api/const/error';
import { Member } from '../../api/model/Member';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
import { RemoveMemberParams } from '../params/RemoveMemberParams';
export declare class RemoveMemberHandler extends IMBaseHandler {
    inboxType: number;
    constructor(context: IMSdkContext, inboxType: number);
    get tag(): string;
    remove(params: RemoveMemberParams): Promise<IMResult<Member[]>>;
    handleResponse(item: RequestItem, params: RemoveMemberParams): Promise<Nullable<Member[]>>;
    /**
     * 解决：内存创建待移除的成员列表，只赋值uid、conversationId
     * 问题：cmd先接受到移除成员事件，成员表先被移除，在本次http response时本地获取到待移除列表为null
     */
    createCacheMemberList(conversationId: Nullable<string>, needRemoveIds: string[]): Member[];
    protected handleError(e: RequestError): void;
    isSuccess(item: RequestItem): boolean;
}

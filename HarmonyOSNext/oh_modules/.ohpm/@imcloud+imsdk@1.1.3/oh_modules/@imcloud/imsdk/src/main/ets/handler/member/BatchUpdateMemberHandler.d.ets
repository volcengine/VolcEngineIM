import { RequestError } from '../../api/const/error';
import { Member } from '../../api/model/Member';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class BatchUpdateMemberHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    /**
     * 修改群成员权限角色
     * @param convId
     * @param toUpdateUidList
     * @param role
     * @param map
     * @returns 修改成功后返回所有更新成功的成员Member结构；否则返回undefined
     */
    changeRole(convId: string, toUpdateUidList: string[], role: im_proto.GroupRole, map?: Nullable<Map<string, string>>): Promise<Nullable<Member[]>>;
    private handleResponse;
    isSuccess(item: RequestItem): boolean;
    protected handleError(e: RequestError): void;
}

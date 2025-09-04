import { IMResult } from '../../api/bean/IMHandlerResult';
import { Conversation } from '../../api/model/Conversation';
import { Member } from '../../api/model/Member';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class UpdateMemberHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    protected forceHttp(): boolean;
    /**
     * 修改群成员备注名
     * @param convId
     * @param uid
     * @param alias
     * @param map
     * @returns 修改成功后返回对应该成员Member数据结构；否则返回undefined
     */
    changeAlias(convId: string, uid: string, alias: string, map?: Nullable<Map<string, string>>): Promise<IMResult<Member>>;
    /**
     * 修改群成员权限角色
     * @param convId
     * @param uid
     * @param role
     * @param map
     * @returns 修改成功后返回该成员Member结构；否则返回undefined
     */
    changeRole(convId: string, uid: string, role: im_proto.GroupRole, map?: Nullable<Map<string, string>>): Promise<IMResult<Member>>;
    handleResponse(item: RequestItem, conversation: Conversation): Promise<Nullable<Member>>;
    isSuccess(item: RequestItem): boolean;
}

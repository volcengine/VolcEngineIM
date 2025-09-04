import { BIMResult, RequestItem } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { IMBaseHandler } from '../../handler/base/IMBaseHandler';
export declare class UpdateLiveGroupMemberHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    protected forceHttp(): boolean;
    protected isSuccess(item: RequestItem): boolean;
    changeRole(conversationShortId: string, uid: string, uidStr: string, role: number): Promise<BIMResult<boolean>>;
    /**
     * @param conversationShortId
     * @param uid
     * @param alias               群成员昵称
     * @param isAliasCover        是否覆盖服务端群昵称
     * @param avatarUrl           群成员头像
     * @param isAvatarCover       是否覆盖服务端群昵称
     * @param ext
     * @return
     */
    updateMemberInfo(conversationShortId: string, uid: string, uidStr: string, alias: string | null, isAliasCover: boolean, avatarUrl: string | null, isAvatarCover: boolean, ext: Map<string, string> | null): Promise<BIMResult<boolean>>;
    updateAlias(conversationShortId: string, uid: string, uidStr: string, alias: string): Promise<BIMResult<boolean>>;
    updateAvatar(conversationShortId: string, uid: string, uidStr: string, avatarUrl: string): Promise<BIMResult<boolean>>;
    addExt(conversationShortId: string, uid: string, uidStr: string, ext: Map<string, string>): Promise<BIMResult<boolean>>;
}

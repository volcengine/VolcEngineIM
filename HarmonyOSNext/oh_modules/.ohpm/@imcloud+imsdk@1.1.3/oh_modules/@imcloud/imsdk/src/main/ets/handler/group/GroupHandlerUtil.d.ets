import { im_proto } from '../../api/proto';
import { IMSdkBaseObject } from '../../core/IMSdkBaseObject';
/**
 * 群聊相关Handler的帮助类，对标Android的GetGroupSettingInfoHandlerMultiInstanceExt
 */
export declare class GroupHandlerUtil {
    static saveGroupManageSettingLocalAsync(baseObj: IMSdkBaseObject, groupManagerInfo: im_proto.IGetGroupManagerInfoResponseBody, conversationId: string): Promise<Nullable<boolean>>;
}

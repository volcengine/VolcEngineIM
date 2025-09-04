import { IMResult } from '../../api/bean/IMHandlerResult';
import { SilentMemberInfo } from '../../api/model/SilentMemberInfo';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class SilentMemberHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    /**
     * 群成员禁言
     * @param isSilent
     * @param convId
     * @param silentMemberList
     * @param bizExtMap
     * @returns 参数异常返回undefined；操作成功则返回空的bigint列表；操作失败则返回失败的用户uid列表
     */
    setMemberSilent(isSilent: boolean, convId: string, silentMemberList: SilentMemberInfo[], bizExtMap?: Map<string, string>): Promise<IMResult<bigint[]>>;
    isSuccess(item: RequestItem): boolean;
}

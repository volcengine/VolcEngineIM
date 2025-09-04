import { IMResult } from '../../../../../Index';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
/***
 * 会话禁言
 */
export declare class SilentConversationHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    /**
     * 群成员禁言
     * @param convId 会话id
     * @param isSilent true 禁言；false 解除禁言
     * @param silentNormalOnly  只禁言普通成员，默认是所有人都被禁言
     * @returns
     */
    setConversationSilent(convId: string, isSilent: boolean, silentNormalOnly: boolean): Promise<IMResult<boolean>>;
    isSuccess(item: RequestItem): boolean;
}

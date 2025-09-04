import { ParticipantIndexInfo } from '../../../api/model/ParticipantIndexInfo';
import { IMSdkContext } from '../../../client/IMSdkContext';
import { IMBaseHandler } from '../../base/IMBaseHandler';
export declare class IMCloudBatchGetMemberReadIndexHandler extends IMBaseHandler {
    private readonly _tag;
    constructor(context: IMSdkContext);
    getReadIndex(cidList: string[]): Promise<Map<string, Map<bigint, ParticipantIndexInfo>>>;
    protected forceHttp(): boolean;
}

import { IMResult } from '../../api/bean/IMHandlerResult';
import { im_proto } from '../../api/proto';
import { IMSdkContext } from '../../client/IMSdkContext';
import { RequestItem } from '../../request/RequestItem';
import { IMBaseHandler } from '../base/IMBaseHandler';
export declare class GetConversationParticipantsMinIndexHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get(conversationId: string): Promise<IMResult<im_proto.ParticipantMinIndex[]>>;
    protected isSuccess(item: RequestItem): boolean;
}

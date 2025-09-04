import { ConversationUtils } from '../utils/ConversationUtils';
import { MessageUtil } from '../utils/MessageUtil';
import { StrangerUtil } from '../utils/StrangerUtil';
import { IMSdkContext } from './IMSdkContext';
export declare class IMUtilService {
    messageUtil: MessageUtil;
    conversationUtil: ConversationUtils;
    strangerUtil: StrangerUtil;
    constructor(context: IMSdkContext);
}

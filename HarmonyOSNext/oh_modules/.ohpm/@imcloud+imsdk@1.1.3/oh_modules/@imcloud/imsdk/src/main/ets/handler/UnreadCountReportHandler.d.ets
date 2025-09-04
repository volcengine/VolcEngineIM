import { IMSdkContext } from '../client/IMSdkContext';
import { IMBaseHandler } from './base/IMBaseHandler';
export declare class UnreadCountReportHandler extends IMBaseHandler {
    constructor(context: IMSdkContext);
    get tag(): string;
    report(inbox: number, needCheck: boolean, totalUnreadCount: number, showTotalUnread: number): Promise<boolean>;
}

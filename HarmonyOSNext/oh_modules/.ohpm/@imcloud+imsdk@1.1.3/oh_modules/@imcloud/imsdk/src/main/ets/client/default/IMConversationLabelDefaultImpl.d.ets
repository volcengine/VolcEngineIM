import { IIMConversationLabelCalculator } from '../../api/depend/IIMCalculatorDepend';
import { Conversation } from '../../api/model/Conversation';
export declare class IMConversationLabelDefaultImpl implements IIMConversationLabelCalculator {
    labelConfig(): Nullable<Set<string>[]>;
    syncMultiLabel(conversation: Conversation[], allowFetchFromNetwork: boolean): Promise<Conversation[]>;
    supportBtoCEnterpriseMode(): boolean;
}

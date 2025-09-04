import { AbstractIMCalculatorDepend, IIMConversationLabelCalculator, IIMUnreadCountCalculatorDepend } from '../../api/depend/IIMCalculatorDepend';
import { IIMSdkRandomDepend } from '../../api/depend/IIMSdkRandomDepend';
export declare class BIMCalculatorDepend extends AbstractIMCalculatorDepend {
    randomDepend: IIMSdkRandomDepend;
    unreadCountCalculator: IIMUnreadCountCalculatorDepend;
    conversationLabelCalculator: IIMConversationLabelCalculator;
}

import { IIMSortOrderCalculatorDepend } from '../../api/depend/IIMCalculatorDepend';
import { Conversation } from '../../api/model/Conversation';
import { Message } from '../../api/model/Message';
/**
 * 默认实现，可以业务注入
 */
export declare class IMConversationSortOrderDefaultImpl implements IIMSortOrderCalculatorDepend {
    needCalculate(msg?: Message): boolean;
    calculate(c?: Conversation): number;
}

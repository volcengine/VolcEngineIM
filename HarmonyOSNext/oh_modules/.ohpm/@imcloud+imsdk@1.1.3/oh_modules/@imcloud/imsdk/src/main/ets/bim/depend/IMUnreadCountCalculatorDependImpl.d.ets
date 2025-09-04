/**
 * 这个类只是占位，真正的执行的类是IMUnreadCountCalculatorDepend
 */
import { IIMUnreadCountCalculatorDepend } from '../../api/depend/IIMCalculatorDepend';
import { Conversation } from '../../api/model/Conversation';
export declare class IMUnreadCountCalculatorDependImpl implements IIMUnreadCountCalculatorDepend {
    calculateUnreadCount(conversation: Conversation): Promise<number>;
    getConversationDowngradeExpireTime(): number;
}

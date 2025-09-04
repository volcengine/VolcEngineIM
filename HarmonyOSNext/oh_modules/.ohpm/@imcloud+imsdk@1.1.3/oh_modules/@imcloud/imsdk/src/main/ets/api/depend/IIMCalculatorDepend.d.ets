import { IMConversationLabelDefaultImpl } from '../../client/default/IMConversationLabelDefaultImpl';
import { IMConversationSortOrderDefaultImpl } from '../../client/default/IMConversationSortOrderDefaultImpl';
import { Conversation } from '../model/Conversation';
import { Message } from '../model/Message';
import { IIMSdkRandomDepend } from './IIMSdkRandomDepend';
/**
 * 所有IMSDK内部依赖外部计算逻辑的一些注入，比如未读数计算、sortOrder计算等
 */
export interface IIMCalculatorDepend {
    /**
     * sortOrder计算依赖
     */
    sortOrderCalculatorDepend: IIMSortOrderCalculatorDepend;
    /**
     * 未读数相关依赖逻辑注入
     */
    unreadCountCalculator: IIMUnreadCountCalculatorDepend;
    /**
     * 生成随机数的能力注入
     */
    randomDepend: IIMSdkRandomDepend;
    /**
     * 会话标签能力注入
     */
    conversationLabelCalculator: IIMConversationLabelCalculator;
}
export declare abstract class AbstractIMCalculatorDepend implements IIMCalculatorDepend {
    abstract randomDepend: IIMSdkRandomDepend;
    abstract unreadCountCalculator: IIMUnreadCountCalculatorDepend;
    sortOrderCalculatorDepend: IIMSortOrderCalculatorDepend;
    conversationLabelCalculator: IIMConversationLabelCalculator;
}
/**
 * 会话sortOrder计算规则，不设置则走默认计算规则
 * 对齐 android SortOrderCalculator
 */
export interface IIMSortOrderCalculatorDepend {
    /**
     * @return 计算得到的sortOrder值
     */
    calculate(c?: Conversation): number;
    /**
     * @return true表示该消息参与sortOrder计算，false表示该消息不参与sortOrder计算
     * 详见：https://bytedance.feishu.cn/wiki/wikcniVwVkC7C9AYgOlat4OKSgg#mYCC2S
     */
    needCalculate(msg?: Message): boolean;
}
export interface IIMUnreadCountCalculatorDepend {
    getConversationDowngradeExpireTime(): number;
    calculateUnreadCount(conversation: Conversation): Promise<number>;
}
/**
 * 对齐Android的ConversationLabelCalculator2
 */
export interface IIMConversationLabelCalculator {
    labelConfig(): Nullable<Set<string>[]>;
    /**
     * 批量计算会话标签，用在冷启动更新数据，耗时方法
     */
    syncMultiLabel(conversation: Nullable<Conversation[]>, allowFetchFromNetwork: Nullable<boolean>): Promise<Nullable<Conversation[]>>;
    supportBtoCEnterpriseMode(): boolean;
}
export declare const defaultSortOrder: IMConversationSortOrderDefaultImpl;
export declare const defaultConversationLabelCal: IMConversationLabelDefaultImpl;

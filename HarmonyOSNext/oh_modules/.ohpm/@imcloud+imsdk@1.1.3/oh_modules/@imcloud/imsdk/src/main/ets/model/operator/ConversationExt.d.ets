import { PartMsgReminderSettingInfo } from '../../api/bean/message/PartMsgReminderSettingInfo';
import { Conversation } from '../../api/model/Conversation';
import { Message } from '../../api/model/Message';
/**
 * 对齐Android的ConversationExt，类似kotlin里面Conversation的扩展方法
 *
 * 一些Conversation的静态方法
 */
export declare class ConversationExt {
    static getPartMsgReminderSettingList(conversation: Conversation): PartMsgReminderSettingInfo[];
    static getNewPartMsgReminderSettingList(conversation: Conversation): PartMsgReminderSettingInfo[];
    static isPartMsgReminder(conversation: Conversation): boolean;
    static hasConvertHistoryGroupOwnerMsgToFlag(conversation: Conversation): boolean;
    static isRecommendGroup(conversation: Conversation): boolean;
    static getNewUnreadSkipMuteCount(conversation: Conversation, ignoreMuteSetting: boolean): number;
    static isSkipMuteMessage(message: Message, conversation: Conversation, currentUid: string): boolean;
    static getPartMsgReminderSettingMap(conversation: Conversation): Map<string, string>;
    /**
     * 获取要存储更新的部分消息配置
     */
    static getPartMsgReminderSettingKVMap(conversation: Conversation): Map<string, string>;
    static getLabelSettingKVMap(conversation: Conversation): Map<string, string>;
}

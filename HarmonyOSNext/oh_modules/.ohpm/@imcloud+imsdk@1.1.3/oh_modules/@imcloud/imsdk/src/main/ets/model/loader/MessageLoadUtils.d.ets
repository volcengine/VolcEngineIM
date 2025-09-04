import { Message } from '../../api/model/Message';
import { Range } from '../../manager/RecentLinkRangeManager';
/**
 * 消息加载Utils类，工具属性逻辑收敛于此
 * @param originMsgList
 * @returns
 */
export declare class MessageLoadUtils {
    /**
     * 获取一个区间内所有连续子区间
     * 比如输入[1,2,3,4,5,8,9,14,23,45,67]
     * 输出[1,2,3,4,5]、[8,9]、[14]、[23]、[45]、[67]
     * @param originMsgList
     * @return [所有连续消息子序列，所有连续消息子序列之间间隔的消息缺失区间]
     */
    static getAllContinuousMsgList(originMsgList: Nullable<Message[]>): [Message[][], Range[]] | undefined;
    /**
     * 从新到旧遍历消息列表，获取最长连续消息子串
     * @param originMsgList DB拿到的原始数据是从旧到新的顺序：[0,1,2,3...]是从屏幕顶部开始往屏幕下方最新消息的顺序
     * @returns 连续最长子消息串：与originMsgList的顺序一致（从旧到新）
     */
    static getSubContinuousMsgList(originMsgList: Nullable<Message[]>): [number, Message[]];
}

import { Message } from '../api/model/Message';
import { MessageListLoadResult } from './IMessageObserver';
/**
 * 会话单聊/群聊点击进入的消息详情页加载监听
 * 通知回调的顺序为:
 *
 *                                   -> (若消息有空洞)onLoadMsgByIndexV2 -> (空洞修复完成) onLeakRepairEnd -> onLoadNewer加载新消息 -> onLoadOlder 用户手动滑动到历史消息
 *                                 /
 * 点击进入会话 --> onInitMsgList --
 *                                 \
 *                                   -> (若消息列表连续、没有空洞) onLoadNewer加载新消息 -> onLoadOlder 用户手动滑动到历史消息
 */
export interface IMessageListObserver {
    /**
     * 点击会话进入消息页、消息列表回调数据
     * 1. 为了更快的让连续的消息上屏，即时存在消息空洞，也会返回给业务连续的消息列表
     * 2. 等待消息补洞完成后，业务会收到onLeakRepairEnd，业务需要处理将拿到的消息填充到对应的消息空洞位置
     * @see onLeakRepairEnd
     */
    onInitMsgList(messageListLoadResult: MessageListLoadResult): void;
    /**
     * 拉取更多
     *
     * @param list
     */
    onLoadOlder(messageListLoadResult: MessageListLoadResult): void;
    /**
     * 拉取更新
     *
     * @param list
     */
    onLoadNewer(messageListLoadResult: MessageListLoadResult): void;
    /**
     * 消息空洞修复全部完成的通知回调
     * 业务拿到leakRepairedMsgList自行插入到对应的消息位置，注意去重
     * @param convId 会话id
     * @param leakRepairedMsgList 消息空洞修复得到的新增消息
     */
    onLeakRepairEnd(convId: string, leakRepairedMsgList: Message[]): void;
}

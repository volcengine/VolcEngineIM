import { Message } from '../api/model/Message';
/**
 * 处理消息已读状态配置
 */
export interface IMsgReadStatusObserver {
    onGetMsg: (msgList: Message[]) => void;
}

/***
 * 搜索相关能力注入
 */
import { Message } from '../model/Message';
export interface IIMSearchDepend {
    /**
     * 构建消息搜索体
     */
    getSearchContent(message: Message): string;
    /***
     * 支持搜索的消息类型
     */
    getSearchMsgType(): number[];
}

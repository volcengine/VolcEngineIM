import { Conversation } from '../model/Conversation';
import { Message } from '../model/Message';
import { MessageFilterResult } from './MessageFilterResult';
export interface IMessageFilterV2 {
    /**
     * @param filterLocalExt 混链GetUserMsgHandler同时处理 多个msg时，会先本地保存在这里，然后统一存入 Conversation
     * @return true if it's a satisfied message
     */
    doFilter?: (from: string, message: Message, filterLocalExt: Map<string, string>, conversation: Nullable<Conversation>) => MessageFilterResult;
    messageNeedDoFilter?: (msg: Nullable<Message>) => boolean;
}

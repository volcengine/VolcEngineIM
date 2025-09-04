import { Message } from '../model/Message';
export interface IHintMessageFilter {
    filter: (msg: Message) => boolean;
}

import { Message } from '../api/model/Message';
export interface IP2PMessageObserver {
    onGetPtoPMessage: (inbox: number, sendType: number, message: Message) => void;
}

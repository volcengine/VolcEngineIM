import { WsChannelImpl } from '../core/WsChannelImpl';
export class WsChannelSdk {
    static registerChannel(c5, d5) {
        let e5 = new WsChannelImpl(c5, d5);
        e5.init();
        return e5;
    }
}

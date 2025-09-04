import connection from '@ohos.net.connection';
import { Logger } from '../../utils/Logger';
import List from "@ohos.util.List";
export class WsNetworkChangeNotifier {
    constructor() {
        this.listenerList = new List();
        this.netConnection = connection.createNetConnection();
        this.registerNetworkChangeCallback();
    }
    register(f7) {
        this.listenerList.add(f7);
    }
    unregister(e7) {
        this.listenerList.remove(e7);
    }
    registerNetworkChangeCallback() {
        this.netConnection.register((w6) => {
            if (w6) {
                Logger.debug(WsNetworkChangeNotifier.TAG + JSON.stringify(w6));
                return;
            }
            Logger.debug(WsNetworkChangeNotifier.TAG + "registerNetworkChangeCallback");
            this.netConnection.on("netAvailable", (c7) => {
                Logger.debug(WsNetworkChangeNotifier.TAG + "netAvailable netId:" + c7.netId);
                for (let d7 = 0; d7 < this.listenerList.length; ++d7) {
                    this.listenerList[d7].netAvailable(c7.netId);
                }
            });
            this.netConnection.on('netLost', (b7) => {
                Logger.debug(WsNetworkChangeNotifier.TAG + "netLost, data:" + JSON.stringify(b7));
            });
            this.netConnection.on('netCapabilitiesChange', (a7) => {
                Logger.debug(WsNetworkChangeNotifier.TAG + "netCapabilitiesChange, data:" + JSON.stringify(a7));
            });
        });
    }
}
WsNetworkChangeNotifier.TAG = "[WsNetworkChangeNotifier]";
export const wsNetworkChangeNotifier = new WsNetworkChangeNotifier();

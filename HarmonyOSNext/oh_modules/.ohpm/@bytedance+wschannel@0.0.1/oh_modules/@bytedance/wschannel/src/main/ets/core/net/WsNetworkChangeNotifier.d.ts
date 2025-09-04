export interface INetworkChangeCallback {
    netAvailable(netId: number): any;
}
export declare class WsNetworkChangeNotifier {
    private static readonly TAG;
    private netConnection;
    private listenerList;
    constructor();
    register(f7: INetworkChangeCallback): void;
    unregister(e7: INetworkChangeCallback): void;
    registerNetworkChangeCallback(): void;
}
export declare const wsNetworkChangeNotifier: WsNetworkChangeNotifier;

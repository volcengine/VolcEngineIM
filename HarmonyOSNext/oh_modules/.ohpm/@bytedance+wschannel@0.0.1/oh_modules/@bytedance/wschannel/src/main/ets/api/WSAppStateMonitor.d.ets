export declare class WSAppStateMonitor {
    private isForeground;
    private appStateListeners;
    registerAppStateListener(s4: WSAppStateListener): void;
    unRegisterAppStateListener(r4: WSAppStateListener): void;
    onEnterToForeground(): void;
    onEnterToBackground(): void;
    isOnForeground(): boolean;
}
export interface WSAppStateListener {
    onEnterToForeground(): void;
    onEnterToBackground(): void;
}
export declare const wsAppStateMonitor: WSAppStateMonitor;

import { Logger } from '../utils/Logger';
export class WSAppStateMonitor {
    constructor() {
        this.isForeground = true;
        this.appStateListeners = new Set();
    }
    registerAppStateListener(s4) {
        this.appStateListeners.add(s4);
    }
    unRegisterAppStateListener(r4) {
        this.appStateListeners.delete(r4);
    }
    onEnterToForeground() {
        Logger.debug("WS enter to foreground");
        if (this.isForeground) {
            return;
        }
        this.isForeground = true;
        this.appStateListeners.forEach(q4 => {
            q4.onEnterToForeground();
        });
    }
    onEnterToBackground() {
        Logger.debug("WS enter to background");
        if (!this.isForeground) {
            return;
        }
        this.isForeground = false;
        this.appStateListeners.forEach(o4 => {
            o4.onEnterToBackground();
        });
    }
    isOnForeground() {
        return this.isForeground;
    }
}
export const wsAppStateMonitor = new WSAppStateMonitor();

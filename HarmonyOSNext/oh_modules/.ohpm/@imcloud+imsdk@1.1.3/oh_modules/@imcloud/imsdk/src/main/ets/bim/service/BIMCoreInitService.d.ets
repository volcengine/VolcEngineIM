import { IMAccessor, InnerService } from "@imcloud/imsdk_common";
import { BIMSyncServerListener } from "../api/interface/BIMSyncServerListener";
import { BIMServiceManager } from "./BIMServiceManager";
export declare class BIMCoreInitService implements InnerService {
    private readonly _tag;
    syncServerListener: BIMSyncServerListener[];
    private syncStatus;
    private _serviceManager;
    constructor(context: Context, serviceManager: BIMServiceManager);
    init(context: Context, imAccessor: IMAccessor): void;
    unInit(context: Context): void;
    onLogin(context: Context, uid: bigint): void;
    onLogout(): void;
    initStart(): void;
    handleInitMessageEnd(inbox: number, success: boolean): void;
    addSyncServerListener(listener: BIMSyncServerListener): boolean;
    log(tag: string, content: string): void;
    removeSyncServerListener(listener: BIMSyncServerListener): boolean;
    updateSyncStatus(status: number): void;
    notifySyncStatus(): void;
}

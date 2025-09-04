import { IMSdkContext } from '../../client/IMSdkContext';
import { BaseRdbManager } from './BaseRdbManager';
import relationalStore from '@ohos.data.relationalStore';
export declare class IMMessageRdbManager extends BaseRdbManager {
    private static readonly DB_VERSION;
    private readonly index;
    constructor(context: IMSdkContext, index: number);
    clearData(): Promise<void>;
    protected getVersion(): number;
    protected onCreateTable(rdb?: relationalStore.RdbStore): Promise<void>;
    protected onCreateIndex(rdb?: relationalStore.RdbStore): Promise<void>;
    protected getDbName(): string;
    protected onUpgrade(oldVersion: number, newVersion: number, rdb?: relationalStore.RdbStore): Promise<void>;
    protected onDowngrade(oldVersion: number, newVersion: number, rdb?: relationalStore.RdbStore): Promise<void>;
}

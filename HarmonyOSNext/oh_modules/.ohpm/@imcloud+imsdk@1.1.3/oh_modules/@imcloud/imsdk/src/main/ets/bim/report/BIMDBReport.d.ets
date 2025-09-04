import { BIMReporterManager } from './BIMReporterManager';
export declare class BIMDBReport {
    private reportManager;
    constructor(manager: BIMReporterManager);
    reportUpgrade(oldVersion: number, newVersion: number, e: object): void;
}

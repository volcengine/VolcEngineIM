import { Config } from './Config';
export declare class MonitorCrash {
    private _context;
    private _config;
    private _appLog;
    static sContext: Context;
    constructor(w3: Context, x3: Config);
    static init(t3: Context, u3: Config): MonitorCrash;
    start(): void;
    get config(): Config;
    lunchEvent(): void;
    private initAppLog;
}

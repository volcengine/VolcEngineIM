import { Config } from './Config';
export declare class Settings {
    private static settings;
    static init(y9: Context, z9: Config): Promise<void>;
    static parse(s9: string, t9: string): void;
    static interval(q9: string): number;
    static isEnable(o9: string): boolean;
    static isCrashEnable(m9: string): boolean;
}
declare class BaseModule {
    switcher: number;
}
export declare class CrashModule extends BaseModule {
}
export {};

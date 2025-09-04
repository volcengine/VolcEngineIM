import { preferences } from '@kit.ArkData';
export declare class KVStorage {
    static readonly AppLogOptions: preferences.Options;
    static readonly KEY_DEVICE_ID: string;
    static storage: preferences.Preferences | undefined;
    static getPreferences(o1: Context): preferences.Preferences;
}

import preferences from "@ohos.data.preferences";
export class KVStorage {
    static getPreferences(o1) {
        if (KVStorage.storage === undefined) {
            KVStorage.storage = preferences.getPreferencesSync(o1, KVStorage.AppLogOptions);
        }
        return KVStorage.storage;
    }
}
KVStorage.AppLogOptions = { name: 'apm_applog' };
KVStorage.KEY_DEVICE_ID = '_device_id';
KVStorage.storage = undefined;

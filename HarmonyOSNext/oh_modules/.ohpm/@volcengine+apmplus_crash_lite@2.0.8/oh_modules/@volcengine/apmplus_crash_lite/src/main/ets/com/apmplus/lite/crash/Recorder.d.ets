import preferences from '@ohos.data.preferences';
import { HashMap } from '@kit.ArkTS';
export default class Recorder {
    static npths: HashMap<string, preferences.Preferences>;
    static initPreferences(j9: Context, k9: string): void;
    static onUpload(h9: Context, i9: string): void;
    static getLastUpload(e9: Context, f9: string): preferences.ValueType;
}

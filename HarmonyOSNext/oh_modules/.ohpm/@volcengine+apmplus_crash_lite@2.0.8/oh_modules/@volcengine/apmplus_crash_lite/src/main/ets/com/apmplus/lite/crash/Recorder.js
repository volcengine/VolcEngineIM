import preferences from '@ohos.data.preferences';
import systemDateTime from '@ohos.systemDateTime';
import HashMap from "@ohos.util.HashMap";
import AppInfo from '../../../bytedance/hpem/util/AppInfo';
const KEY_LAST_UPLOAD = 'key_last_upload';
export default class Recorder {
    static initPreferences(j9, k9) {
        if (Recorder.npths.get(k9) === undefined) {
            Recorder.npths.set(k9, preferences.getPreferencesSync(j9, { name: `apm_lite_${k9}` }));
        }
    }
    static onUpload(h9, i9) {
        Recorder.initPreferences(h9, i9);
        Recorder.npths.get(i9)?.putSync(KEY_LAST_UPLOAD, systemDateTime.getTime());
        Recorder.npths.get(i9)?.flush();
    }
    static getLastUpload(e9, f9) {
        Recorder.initPreferences(e9, f9);
        let g9 = Recorder.npths.get(f9)?.getSync(KEY_LAST_UPLOAD, AppInfo.install_time);
        return g9;
    }
}
Recorder.npths = new HashMap();

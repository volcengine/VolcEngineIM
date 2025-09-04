import { FileUtils } from '../util/FileUtils';
import fs from '@ohos.file.fs';
const HOME = 'apm';
const SETTING_NAME = 'setting_';
export class SettingStorage {
    constructor(z15, a16) {
        this.path = '';
        let b16 = a16.filesDir + '/' + HOME;
        if (!fs.accessSync(b16)) {
            fs.mkdirSync(b16);
        }
        this.path = b16 + '/' + SETTING_NAME + z15 + ".txt";
    }
    getSetting() {
        let x15 = '';
        try {
            x15 = FileUtils.read(this.path);
        }
        catch (y15) {
        }
        return x15;
    }
    saveSetting(w15) {
        if (fs.accessSync(this.path)) {
            fs.truncateSync(this.path, 0);
        }
        FileUtils.write(w15, this.path, false);
    }
}

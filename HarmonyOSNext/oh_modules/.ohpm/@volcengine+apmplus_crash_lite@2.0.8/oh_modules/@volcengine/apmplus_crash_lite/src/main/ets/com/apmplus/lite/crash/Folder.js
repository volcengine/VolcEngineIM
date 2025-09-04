import fs from '@ohos.file.fs';
import { Logger } from './Logger';
const HOME = "apm_lite";
const CRASH_PATH = '/crash';
const CONFIG_PATH = '/config';
export default class Folder {
    static initHomeDir(k3, l3) {
        try {
            let n3 = k3.filesDir + '/' + HOME;
            if (!fs.accessSync(n3)) {
                fs.mkdirSync(n3);
            }
            n3 = Folder.getFileDir(k3, l3);
            if (!fs.accessSync(n3)) {
                fs.mkdirSync(n3);
            }
            n3 = Folder.getCrashDir(k3, l3);
            if (!fs.accessSync(n3)) {
                fs.mkdirSync(n3);
            }
            n3 = Folder.getCacheDir(k3);
            if (!fs.accessSync(n3)) {
                fs.mkdirSync(n3);
            }
            n3 = Folder.getTempDir(k3);
            if (!fs.accessSync(n3)) {
                fs.mkdirSync(n3);
            }
        }
        catch (m3) {
            Logger.error('Init Home dir ', m3);
        }
    }
    static getFileDir(i3, j3) {
        return i3.filesDir + '/' + HOME + '/' + j3;
    }
    static getCacheDir(h3) {
        return h3.cacheDir + '/' + HOME;
    }
    static getTempDir(g3) {
        return g3.tempDir + '/' + HOME;
    }
    static getCrashDir(c3, d3, e3 = '') {
        let f3 = Folder.getFileDir(c3, d3) + CRASH_PATH + '/' + e3;
        if (!fs.accessSync(f3)) {
            fs.mkdirSync(f3);
        }
        return f3;
    }
    static getConfigDir(z2, a3) {
        let b3 = Folder.getFileDir(z2, a3) + CONFIG_PATH;
        if (!fs.accessSync(b3)) {
            fs.mkdirSync(b3);
        }
        return b3;
    }
    static getSubDir(w2, x2) {
        if (!fs.accessSync(w2)) {
            return '';
        }
        if (!w2.endsWith('/')) {
            w2 = w2 + '/';
        }
        let y2 = w2 + x2;
        if (!fs.accessSync(y2)) {
            fs.mkdirSync(y2);
        }
        return y2;
    }
}

import fs from '@ohos.file.fs';
import { HpemLog } from './HpemLog';
export class FileUtils {
    static write(o17, p17, q17 = false) {
        let r17 = null;
        try {
            if (q17) {
                r17 = fs.openSync(p17, fs.OpenMode.READ_WRITE | fs.OpenMode.APPEND);
            }
            else {
                r17 = fs.openSync(p17, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            }
            fs.writeSync(r17.fd, o17);
            return true;
        }
        catch (t17) {
            HpemLog.error('write to ' + p17, t17);
        }
        finally {
            try {
                if (r17 !== null) {
                    fs.closeSync(r17);
                }
            }
            catch (s17) {
            }
        }
        return false;
    }
    static copyFile(k17, l17, m17) {
        try {
            fs.copyFileSync(k17, l17, m17);
        }
        catch (n17) {
            HpemLog.error('copyFile', n17);
        }
    }
    static readWriteFileWithStream(x16, y16) {
        let z16 = undefined;
        let a17 = undefined;
        try {
            z16 = fs.createStreamSync(x16, 'r');
            a17 = fs.createStreamSync(y16, "w");
            let e17 = 4096;
            let f17 = 0;
            let g17 = new ArrayBuffer(e17);
            class h17 {
                constructor() {
                    this.offset = 0;
                    this.length = e17;
                }
            }
            let i17 = new h17();
            i17.offset = f17;
            let j17 = z16.readSync(g17, i17);
            f17 += j17;
            while (j17 > 0) {
                a17.writeSync(g17);
                i17.offset = f17;
                j17 = z16.readSync(g17, i17);
                f17 += j17;
            }
        }
        catch (d17) {
            HpemLog.error('readWriteFileWithStream', d17);
        }
        finally {
            try {
                z16?.close();
            }
            catch (c17) {
            }
            try {
                a17?.close();
            }
            catch (b17) {
            }
        }
    }
    static deleteDir(v16) {
        try {
            if (!fs.accessSync(v16)) {
                return;
            }
            fs.rmdirSync(v16);
        }
        catch (w16) {
        }
    }
    static deleteFile(t16) {
        try {
            if (!fs.accessSync(t16)) {
                return;
            }
            fs.unlinkSync(t16);
        }
        catch (u16) {
        }
    }
    static read(s16) {
        if (!fs.accessSync(s16)) {
            return '';
        }
        return fs.readTextSync(s16);
    }
    static async trimFile(l16, m16, n16) {
        try {
            if (!fs.accessSync(l16)) {
                return;
            }
            let p16 = fs.listFileSync(l16);
            if (p16.length > m16) {
                p16.sort(n16);
                let q16 = p16.length - m16;
                for (let r16 = 0; r16 < q16; r16++) {
                    fs.unlinkSync(l16 + '/' + p16[r16]);
                }
            }
        }
        catch (o16) {
        }
    }
    static trimDir(e16, f16, g16) {
        try {
            if (!fs.accessSync(e16)) {
                return;
            }
            let i16 = fs.listFileSync(e16);
            if (i16.length > f16) {
                i16.sort(g16);
                let j16 = i16.length - f16;
                for (let k16 = 0; k16 < j16; k16++) {
                    fs.rmdirSync(e16 + '/' + i16[k16]);
                }
            }
        }
        catch (h16) {
        }
    }
}

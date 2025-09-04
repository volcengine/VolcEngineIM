import fs from '@ohos.file.fs';
import ArrayList from '@ohos.util.ArrayList';
import { NetworkClient } from './NetworkClient';
import Buffer from '@ohos.buffer';
export class MultiPartUtility {
    constructor(y13, z13, a14) {
        this.params = new ArrayList();
        this.url = y13;
        this.multipartHeader = z13;
        this.boundary = this.multipartHeader.getBoundary();
        this.line = `--${this.boundary}\r\n`;
        this.networkClient = a14 == undefined ? NetworkClient.getNetworkClient() : a14;
    }
    addFormField(u13, v13, w13 = false) {
        let x13 = new FormMultiPart(u13, v13, this.line);
        this.params.add(x13);
    }
    addFilePart(q13, r13, s13) {
        let t13 = new FileMultiPart(q13, r13, this.line, s13);
        this.params.add(t13);
    }
    finish(j13) {
        try {
            let l13 = `\r\n--${this.boundary}--\r\n`;
            let m13 = [];
            this.params.forEach((p13) => {
                p13.write(m13);
            });
            m13.push(Buffer.from(l13));
            let n13 = Buffer.concat(m13);
            this.networkClient.post(this.url, n13.buffer, this.multipartHeader.getHeader(), j13);
        }
        catch (k13) {
            j13(false);
        }
    }
}
class FormMultiPart {
    constructor(g13, h13, i13) {
        this.part = `${i13}Content-Disposition: form-data; name="${g13}"\r\nContent-Type: text/plain; charset=UTF-8\r\n\r\n${h13}\r\n`;
    }
    write(f13) {
        f13.push(Buffer.from(this.part));
    }
}
class FileMultiPart {
    constructor(x12, y12, z12, a13) {
        this.uploadFile = '';
        this.spilt = '';
        this.uploadFile = x12;
        let b13 = '';
        if (a13 !== undefined) {
            a13.forEach((d13, e13) => {
                b13 = `${b13}; ${e13}="${d13}"`;
            });
        }
        this.spilt = `${z12}Content-Disposition: form-data; name="${y12}"; fileName="${y12}${b13}"\r\nContent-Transfer-Encoding: binary\r\n\r\n`;
    }
    write(t12) {
        t12.push(Buffer.from(this.spilt));
        let u12 = undefined;
        try {
            let w12 = new ArrayBuffer(fs.statSync(this.uploadFile).size);
            u12 = fs.createStreamSync(this.uploadFile, 'r');
            u12.readSync(w12);
            t12.push(Buffer.from(w12));
        }
        finally {
            try {
                u12?.close();
            }
            catch (v12) {
            }
        }
    }
}

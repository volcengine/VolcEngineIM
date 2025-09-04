;
export class Md5 {
    static hashStr(o11, p11 = false) {
        return this.onePassHasher
            .start()
            .appendStr(o11)
            .end(p11);
    }
    static hashArray(m11, n11 = false) {
        return this.onePassHasher
            .start()
            .appendByteArray(m11)
            .end(n11);
    }
    static hashAsciiStr(k11, l11 = false) {
        return this.onePassHasher
            .start()
            .appendAsciiStr(k11)
            .end(l11);
    }
    static _hex(d11) {
        const e11 = Md5.hexChars;
        const f11 = Md5.hexOut;
        let g11;
        let h11;
        let i11;
        let j11;
        for (j11 = 0; j11 < 4; j11 += 1) {
            h11 = j11 * 8;
            g11 = d11[j11];
            for (i11 = 0; i11 < 8; i11 += 2) {
                f11[h11 + 1 + i11] = e11.charAt(g11 & 0x0F);
                g11 >>>= 4;
                f11[h11 + 0 + i11] = e11.charAt(g11 & 0x0F);
                g11 >>>= 4;
            }
        }
        return f11.join('');
    }
    static _md5cycle(x10, y10) {
        let z10 = x10[0];
        let a11 = x10[1];
        let b11 = x10[2];
        let c11 = x10[3];
        z10 += (a11 & b11 | ~a11 & c11) + y10[0] - 680876936 | 0;
        z10 = (z10 << 7 | z10 >>> 25) + a11 | 0;
        c11 += (z10 & a11 | ~z10 & b11) + y10[1] - 389564586 | 0;
        c11 = (c11 << 12 | c11 >>> 20) + z10 | 0;
        b11 += (c11 & z10 | ~c11 & a11) + y10[2] + 606105819 | 0;
        b11 = (b11 << 17 | b11 >>> 15) + c11 | 0;
        a11 += (b11 & c11 | ~b11 & z10) + y10[3] - 1044525330 | 0;
        a11 = (a11 << 22 | a11 >>> 10) + b11 | 0;
        z10 += (a11 & b11 | ~a11 & c11) + y10[4] - 176418897 | 0;
        z10 = (z10 << 7 | z10 >>> 25) + a11 | 0;
        c11 += (z10 & a11 | ~z10 & b11) + y10[5] + 1200080426 | 0;
        c11 = (c11 << 12 | c11 >>> 20) + z10 | 0;
        b11 += (c11 & z10 | ~c11 & a11) + y10[6] - 1473231341 | 0;
        b11 = (b11 << 17 | b11 >>> 15) + c11 | 0;
        a11 += (b11 & c11 | ~b11 & z10) + y10[7] - 45705983 | 0;
        a11 = (a11 << 22 | a11 >>> 10) + b11 | 0;
        z10 += (a11 & b11 | ~a11 & c11) + y10[8] + 1770035416 | 0;
        z10 = (z10 << 7 | z10 >>> 25) + a11 | 0;
        c11 += (z10 & a11 | ~z10 & b11) + y10[9] - 1958414417 | 0;
        c11 = (c11 << 12 | c11 >>> 20) + z10 | 0;
        b11 += (c11 & z10 | ~c11 & a11) + y10[10] - 42063 | 0;
        b11 = (b11 << 17 | b11 >>> 15) + c11 | 0;
        a11 += (b11 & c11 | ~b11 & z10) + y10[11] - 1990404162 | 0;
        a11 = (a11 << 22 | a11 >>> 10) + b11 | 0;
        z10 += (a11 & b11 | ~a11 & c11) + y10[12] + 1804603682 | 0;
        z10 = (z10 << 7 | z10 >>> 25) + a11 | 0;
        c11 += (z10 & a11 | ~z10 & b11) + y10[13] - 40341101 | 0;
        c11 = (c11 << 12 | c11 >>> 20) + z10 | 0;
        b11 += (c11 & z10 | ~c11 & a11) + y10[14] - 1502002290 | 0;
        b11 = (b11 << 17 | b11 >>> 15) + c11 | 0;
        a11 += (b11 & c11 | ~b11 & z10) + y10[15] + 1236535329 | 0;
        a11 = (a11 << 22 | a11 >>> 10) + b11 | 0;
        z10 += (a11 & c11 | b11 & ~c11) + y10[1] - 165796510 | 0;
        z10 = (z10 << 5 | z10 >>> 27) + a11 | 0;
        c11 += (z10 & b11 | a11 & ~b11) + y10[6] - 1069501632 | 0;
        c11 = (c11 << 9 | c11 >>> 23) + z10 | 0;
        b11 += (c11 & a11 | z10 & ~a11) + y10[11] + 643717713 | 0;
        b11 = (b11 << 14 | b11 >>> 18) + c11 | 0;
        a11 += (b11 & z10 | c11 & ~z10) + y10[0] - 373897302 | 0;
        a11 = (a11 << 20 | a11 >>> 12) + b11 | 0;
        z10 += (a11 & c11 | b11 & ~c11) + y10[5] - 701558691 | 0;
        z10 = (z10 << 5 | z10 >>> 27) + a11 | 0;
        c11 += (z10 & b11 | a11 & ~b11) + y10[10] + 38016083 | 0;
        c11 = (c11 << 9 | c11 >>> 23) + z10 | 0;
        b11 += (c11 & a11 | z10 & ~a11) + y10[15] - 660478335 | 0;
        b11 = (b11 << 14 | b11 >>> 18) + c11 | 0;
        a11 += (b11 & z10 | c11 & ~z10) + y10[4] - 405537848 | 0;
        a11 = (a11 << 20 | a11 >>> 12) + b11 | 0;
        z10 += (a11 & c11 | b11 & ~c11) + y10[9] + 568446438 | 0;
        z10 = (z10 << 5 | z10 >>> 27) + a11 | 0;
        c11 += (z10 & b11 | a11 & ~b11) + y10[14] - 1019803690 | 0;
        c11 = (c11 << 9 | c11 >>> 23) + z10 | 0;
        b11 += (c11 & a11 | z10 & ~a11) + y10[3] - 187363961 | 0;
        b11 = (b11 << 14 | b11 >>> 18) + c11 | 0;
        a11 += (b11 & z10 | c11 & ~z10) + y10[8] + 1163531501 | 0;
        a11 = (a11 << 20 | a11 >>> 12) + b11 | 0;
        z10 += (a11 & c11 | b11 & ~c11) + y10[13] - 1444681467 | 0;
        z10 = (z10 << 5 | z10 >>> 27) + a11 | 0;
        c11 += (z10 & b11 | a11 & ~b11) + y10[2] - 51403784 | 0;
        c11 = (c11 << 9 | c11 >>> 23) + z10 | 0;
        b11 += (c11 & a11 | z10 & ~a11) + y10[7] + 1735328473 | 0;
        b11 = (b11 << 14 | b11 >>> 18) + c11 | 0;
        a11 += (b11 & z10 | c11 & ~z10) + y10[12] - 1926607734 | 0;
        a11 = (a11 << 20 | a11 >>> 12) + b11 | 0;
        z10 += (a11 ^ b11 ^ c11) + y10[5] - 378558 | 0;
        z10 = (z10 << 4 | z10 >>> 28) + a11 | 0;
        c11 += (z10 ^ a11 ^ b11) + y10[8] - 2022574463 | 0;
        c11 = (c11 << 11 | c11 >>> 21) + z10 | 0;
        b11 += (c11 ^ z10 ^ a11) + y10[11] + 1839030562 | 0;
        b11 = (b11 << 16 | b11 >>> 16) + c11 | 0;
        a11 += (b11 ^ c11 ^ z10) + y10[14] - 35309556 | 0;
        a11 = (a11 << 23 | a11 >>> 9) + b11 | 0;
        z10 += (a11 ^ b11 ^ c11) + y10[1] - 1530992060 | 0;
        z10 = (z10 << 4 | z10 >>> 28) + a11 | 0;
        c11 += (z10 ^ a11 ^ b11) + y10[4] + 1272893353 | 0;
        c11 = (c11 << 11 | c11 >>> 21) + z10 | 0;
        b11 += (c11 ^ z10 ^ a11) + y10[7] - 155497632 | 0;
        b11 = (b11 << 16 | b11 >>> 16) + c11 | 0;
        a11 += (b11 ^ c11 ^ z10) + y10[10] - 1094730640 | 0;
        a11 = (a11 << 23 | a11 >>> 9) + b11 | 0;
        z10 += (a11 ^ b11 ^ c11) + y10[13] + 681279174 | 0;
        z10 = (z10 << 4 | z10 >>> 28) + a11 | 0;
        c11 += (z10 ^ a11 ^ b11) + y10[0] - 358537222 | 0;
        c11 = (c11 << 11 | c11 >>> 21) + z10 | 0;
        b11 += (c11 ^ z10 ^ a11) + y10[3] - 722521979 | 0;
        b11 = (b11 << 16 | b11 >>> 16) + c11 | 0;
        a11 += (b11 ^ c11 ^ z10) + y10[6] + 76029189 | 0;
        a11 = (a11 << 23 | a11 >>> 9) + b11 | 0;
        z10 += (a11 ^ b11 ^ c11) + y10[9] - 640364487 | 0;
        z10 = (z10 << 4 | z10 >>> 28) + a11 | 0;
        c11 += (z10 ^ a11 ^ b11) + y10[12] - 421815835 | 0;
        c11 = (c11 << 11 | c11 >>> 21) + z10 | 0;
        b11 += (c11 ^ z10 ^ a11) + y10[15] + 530742520 | 0;
        b11 = (b11 << 16 | b11 >>> 16) + c11 | 0;
        a11 += (b11 ^ c11 ^ z10) + y10[2] - 995338651 | 0;
        a11 = (a11 << 23 | a11 >>> 9) + b11 | 0;
        z10 += (b11 ^ (a11 | ~c11)) + y10[0] - 198630844 | 0;
        z10 = (z10 << 6 | z10 >>> 26) + a11 | 0;
        c11 += (a11 ^ (z10 | ~b11)) + y10[7] + 1126891415 | 0;
        c11 = (c11 << 10 | c11 >>> 22) + z10 | 0;
        b11 += (z10 ^ (c11 | ~a11)) + y10[14] - 1416354905 | 0;
        b11 = (b11 << 15 | b11 >>> 17) + c11 | 0;
        a11 += (c11 ^ (b11 | ~z10)) + y10[5] - 57434055 | 0;
        a11 = (a11 << 21 | a11 >>> 11) + b11 | 0;
        z10 += (b11 ^ (a11 | ~c11)) + y10[12] + 1700485571 | 0;
        z10 = (z10 << 6 | z10 >>> 26) + a11 | 0;
        c11 += (a11 ^ (z10 | ~b11)) + y10[3] - 1894986606 | 0;
        c11 = (c11 << 10 | c11 >>> 22) + z10 | 0;
        b11 += (z10 ^ (c11 | ~a11)) + y10[10] - 1051523 | 0;
        b11 = (b11 << 15 | b11 >>> 17) + c11 | 0;
        a11 += (c11 ^ (b11 | ~z10)) + y10[1] - 2054922799 | 0;
        a11 = (a11 << 21 | a11 >>> 11) + b11 | 0;
        z10 += (b11 ^ (a11 | ~c11)) + y10[8] + 1873313359 | 0;
        z10 = (z10 << 6 | z10 >>> 26) + a11 | 0;
        c11 += (a11 ^ (z10 | ~b11)) + y10[15] - 30611744 | 0;
        c11 = (c11 << 10 | c11 >>> 22) + z10 | 0;
        b11 += (z10 ^ (c11 | ~a11)) + y10[6] - 1560198380 | 0;
        b11 = (b11 << 15 | b11 >>> 17) + c11 | 0;
        a11 += (c11 ^ (b11 | ~z10)) + y10[13] + 1309151649 | 0;
        a11 = (a11 << 21 | a11 >>> 11) + b11 | 0;
        z10 += (b11 ^ (a11 | ~c11)) + y10[4] - 145523070 | 0;
        z10 = (z10 << 6 | z10 >>> 26) + a11 | 0;
        c11 += (a11 ^ (z10 | ~b11)) + y10[11] - 1120210379 | 0;
        c11 = (c11 << 10 | c11 >>> 22) + z10 | 0;
        b11 += (z10 ^ (c11 | ~a11)) + y10[2] + 718787259 | 0;
        b11 = (b11 << 15 | b11 >>> 17) + c11 | 0;
        a11 += (c11 ^ (b11 | ~z10)) + y10[9] - 343485551 | 0;
        a11 = (a11 << 21 | a11 >>> 11) + b11 | 0;
        x10[0] = z10 + x10[0] | 0;
        x10[1] = a11 + x10[1] | 0;
        x10[2] = b11 + x10[2] | 0;
        x10[3] = c11 + x10[3] | 0;
    }
    constructor() {
        this._dataLength = 0;
        this._bufferLength = 0;
        this._state = new Int32Array(4);
        this._buffer = new ArrayBuffer(68);
        this._buffer8 = new Uint8Array(this._buffer, 0, 68);
        this._buffer32 = new Uint32Array(this._buffer, 0, 17);
        this.start();
    }
    start() {
        this._dataLength = 0;
        this._bufferLength = 0;
        this._state.set(Md5.stateIdentity);
        return this;
    }
    appendStr(r10) {
        const s10 = this._buffer8;
        const t10 = this._buffer32;
        let u10 = this._bufferLength;
        let v10;
        let w10;
        for (w10 = 0; w10 < r10.length; w10 += 1) {
            v10 = r10.charCodeAt(w10);
            if (v10 < 128) {
                s10[u10++] = v10;
            }
            else if (v10 < 0x800) {
                s10[u10++] = (v10 >>> 6) + 0xC0;
                s10[u10++] = v10 & 0x3F | 0x80;
            }
            else if (v10 < 0xD800 || v10 > 0xDBFF) {
                s10[u10++] = (v10 >>> 12) + 0xE0;
                s10[u10++] = (v10 >>> 6 & 0x3F) | 0x80;
                s10[u10++] = (v10 & 0x3F) | 0x80;
            }
            else {
                v10 = ((v10 - 0xD800) * 0x400) + (r10.charCodeAt(++w10) - 0xDC00) + 0x10000;
                if (v10 > 0x10FFFF) {
                    throw new Error('Unicode standard supports code points up to U+10FFFF');
                }
                s10[u10++] = (v10 >>> 18) + 0xF0;
                s10[u10++] = (v10 >>> 12 & 0x3F) | 0x80;
                s10[u10++] = (v10 >>> 6 & 0x3F) | 0x80;
                s10[u10++] = (v10 & 0x3F) | 0x80;
            }
            if (u10 >= 64) {
                this._dataLength += 64;
                Md5._md5cycle(this._state, t10);
                u10 -= 64;
                t10[0] = t10[16];
            }
        }
        this._bufferLength = u10;
        return this;
    }
    appendAsciiStr(l10) {
        const m10 = this._buffer8;
        const n10 = this._buffer32;
        let o10 = this._bufferLength;
        let p10;
        let q10 = 0;
        for (;;) {
            p10 = Math.min(l10.length - q10, 64 - o10);
            while (p10--) {
                m10[o10++] = l10.charCodeAt(q10++);
            }
            if (o10 < 64) {
                break;
            }
            this._dataLength += 64;
            Md5._md5cycle(this._state, n10);
            o10 = 0;
        }
        this._bufferLength = o10;
        return this;
    }
    appendByteArray(f10) {
        const g10 = this._buffer8;
        const h10 = this._buffer32;
        let i10 = this._bufferLength;
        let j10;
        let k10 = 0;
        for (;;) {
            j10 = Math.min(f10.length - k10, 64 - i10);
            while (j10--) {
                g10[i10++] = f10[k10++];
            }
            if (i10 < 64) {
                break;
            }
            this._dataLength += 64;
            Md5._md5cycle(this._state, h10);
            i10 = 0;
        }
        this._bufferLength = i10;
        return this;
    }
    getState() {
        const e10 = this._state;
        return {
            buffer: String.fromCharCode.apply(null, Array.from(this._buffer8)),
            buflen: this._bufferLength,
            length: this._dataLength,
            state: [e10[0], e10[1], e10[2], e10[3]]
        };
    }
    setState(z9) {
        const a10 = z9.buffer;
        const b10 = z9.state;
        const c10 = this._state;
        let d10;
        this._dataLength = z9.length;
        this._bufferLength = z9.buflen;
        c10[0] = b10[0];
        c10[1] = b10[1];
        c10[2] = b10[2];
        c10[3] = b10[3];
        for (d10 = 0; d10 < a10.length; d10 += 1) {
            this._buffer8[d10] = a10.charCodeAt(d10);
        }
    }
    end(q9 = false) {
        const r9 = this._bufferLength;
        const s9 = this._buffer8;
        const t9 = this._buffer32;
        const u9 = (r9 >> 2) + 1;
        this._dataLength += r9;
        const v9 = this._dataLength * 8;
        s9[r9] = 0x80;
        s9[r9 + 1] = s9[r9 + 2] = s9[r9 + 3] = 0;
        t9.set(Md5.buffer32Identity.subarray(u9), u9);
        if (r9 > 55) {
            Md5._md5cycle(this._state, t9);
            t9.set(Md5.buffer32Identity);
        }
        if (v9 <= 0xFFFFFFFF) {
            t9[14] = v9;
        }
        else {
            const w9 = v9.toString(16).match(/(.*?)(.{0,8})$/);
            if (w9 === null) {
                return;
            }
            const x9 = parseInt(w9[2], 16);
            const y9 = parseInt(w9[1], 16) || 0;
            t9[14] = x9;
            t9[15] = y9;
        }
        Md5._md5cycle(this._state, t9);
        return q9 ? this._state : Md5._hex(this._state);
    }
}
Md5.stateIdentity = new Int32Array([1732584193, -271733879, -1732584194, 271733878]);
Md5.buffer32Identity = new Int32Array([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
Md5.hexChars = '0123456789abcdef';
Md5.hexOut = [];
Md5.onePassHasher = new Md5();
if (Md5.hashStr('hello') !== '5d41402abc4b2a76b9719d911017c592') {
    throw new Error('Md5 self test failed.');
}

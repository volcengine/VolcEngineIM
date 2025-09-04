import { FileUtils } from '../../../../bytedance/hpem/util/FileUtils';
import { CrashLib } from './CrashLib';
import HashMap from "@ohos.util.HashMap";
export default class Tombstone {
    constructor(d9) {
        this.mSignal = '';
        this.mBacktrace = '';
        this.mCrashMessage = '';
        this.mCrashLibs = [];
        this.mBuildIds = new HashMap();
        this.mPid = '';
        this.mTid = '';
        this.mProcessName = '';
        this.mThreadName = '';
        this.mSignalStr = '';
        this.mSignalNumber = 0;
        this.mCodeStr = '';
        this.mCodeNumber = 0;
        this.mFatalAddress = '--------';
        this.mFile = d9 + '/tombstone.txt';
    }
    getPid() { return this.mPid; }
    getProcessName() { return this.mProcessName; }
    getTid() { return this.mTid; }
    getThreadName() { return this.mThreadName; }
    getSignal() { return this.mSignal; }
    getBacktrace() {
        let c9 = `Signal ${this.mSignalNumber}(${this.mSignalStr}), code ${this.mCodeNumber}(${this.mCodeStr})\n`;
        if (this.mCrashMessage !== '') {
            return c9 + this.mCrashMessage + this.mBacktrace;
        }
        return c9 + this.mBacktrace;
    }
    getMessage() { return this.mCrashMessage; }
    getCrashLib() {
        return this.mCrashLibs;
    }
    rebuildTombstone(t7) {
        let u7 = '';
        this.mPid = t7.pid.toString();
        let v7 = t7.fullLog;
        let w7 = 0;
        let x7 = 0;
        let y7 = '';
        try {
            w7 = v7.indexOf('Process name:') + 'Process name:'.length;
            v7 = v7.substring(w7);
            x7 = v7.indexOf('\n');
            this.mProcessName = v7.substring(0, x7);
        }
        catch (b9) {
        }
        try {
            w7 = v7.indexOf('Reason:Signal:') + 'Reason:Signal:'.length;
            v7 = v7.substring(w7);
            x7 = v7.indexOf('\n');
            y7 = v7.substring(0, x7);
            this.mSignalStr = y7.substring(0, y7.indexOf('('));
            this.mCodeStr = y7.substring(y7.indexOf('(') + 1, y7.indexOf(')'));
            let y8 = SignalMap.get(this.mSignalStr);
            if (y8 !== undefined) {
                this.mSignalNumber = y8;
            }
            else {
                this.mSignalNumber = -1;
            }
            let z8 = CodeMap.get(this.mCodeStr);
            if (z8 !== undefined) {
                this.mCodeNumber = z8;
            }
            else {
                this.mCodeNumber = -1;
            }
            this.mSignal = `Signal ${this.mSignalNumber}, Code ${this.mCodeNumber}\n`;
            let a9 = y7.split(' ');
            if (a9.length > 1) {
                if (a9[0].includes(')@')) {
                    this.mFatalAddress = a9[0].substring(y7.indexOf(')@') + 2);
                }
                if (a9.length >= 2) {
                    if (this.mSignalNumber === 6) {
                        this.mCrashMessage = "Abort message:" + a9.slice(1).join(' ');
                    }
                    else {
                        this.mCrashMessage = "Crash message:" + a9.slice(1).join(' ');
                    }
                }
            }
        }
        catch (x8) {
        }
        try {
            w7 = v7.indexOf('Tid:') + 'Tid:'.length;
            v7 = v7.substring(w7);
            x7 = v7.indexOf('\n');
            y7 = v7.substring(0, x7);
            x7 = y7.indexOf(',');
            this.mTid = y7.substring(0, x7);
            w7 = y7.indexOf('Name:') + 'Name:'.length;
            x7 = y7.length;
            this.mThreadName = y7.substring(w7, x7);
        }
        catch (w8) {
        }
        try {
            u7 = u7 + `pid: ${this.mPid}, tid: ${this.mTid}, name: ${this.mThreadName}  >>> ${this.mProcessName} <<<\n`;
            u7 = u7 + `signal ${this.mSignalNumber} (${this.mSignalStr}), code ${this.mCodeNumber} (${this.mCodeStr}), fault addr ${this.mFatalAddress}\n`;
            if (this.mCrashMessage !== '') {
                u7 = u7 + this.mCrashMessage;
            }
        }
        catch (v8) {
        }
        try {
            w7 = v7.indexOf('#00');
            v7 = v7.substring(w7);
            x7 = v7.indexOf('Registers:') - 1;
            this.mBacktrace = v7.substring(0, x7);
            this.mBuildIds = this.parseBacktrace(this.mBacktrace);
        }
        catch (u8) {
        }
        try {
            w7 = v7.indexOf('Registers:') + 'Registers:'.length;
            v7 = v7.substring(w7);
            x7 = v7.indexOf('Other thread info:') - 1;
            let q8 = this.registerFormat(v7.substring(0, x7));
            u7 = u7 + '\t' + q8 + '\n';
            u7 = u7 + `\nbacktrace:\n\t${this.mBacktrace.split('\n').join('\n\t')}\n`;
            u7 = u7 + '\nbuild id:\n';
            this.mBuildIds.forEach((s8, t8) => {
                u7 = u7 + `\t${t8} (BuildId: ${s8})\n`;
            });
        }
        catch (p8) {
        }
        try {
            w7 = v7.indexOf('Other thread info:') + 'Other thread info:'.length;
            v7 = v7.substring(w7);
            x7 = v7.indexOf('Memory near registers:') - 1;
        }
        catch (o8) {
        }
        let z7 = v7.substring(0, x7);
        try {
            w7 = v7.indexOf('Memory near registers:') + 'Memory near registers:'.length;
            v7 = v7.substring(w7);
            x7 = v7.indexOf('FaultStack:') - 1;
        }
        catch (n8) {
        }
        let a8 = v7.substring(0, x7);
        try {
            w7 = v7.indexOf('FaultStack:') + 'FaultStack:'.length;
            v7 = v7.substring(w7);
            x7 = v7.indexOf('Maps:') - 1;
            u7 = u7 + '\nstack:' + v7.substring(0, x7);
        }
        catch (m8) {
        }
        try {
            let k8 = a8.split('\n');
            for (const l8 of k8) {
                if (l8.endsWith(':')) {
                    u7 = u7 + '\nmemory near ' + l8 + '\n';
                }
                else {
                    u7 = u7 + l8 + '\n';
                }
            }
        }
        catch (j8) {
        }
        try {
            while (x7 > 0) {
                u7 = u7 + '\n--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---\n';
                w7 = z7.indexOf('Tid:') + 'Tid:'.length;
                z7 = z7.substring(w7);
                x7 = z7.indexOf('\n');
                y7 = z7.substring(0, x7);
                x7 = y7.indexOf(',');
                let c8 = y7.substring(0, x7);
                w7 = y7.indexOf('Name:') + 'Name:'.length;
                x7 = y7.length;
                let d8 = y7.substring(w7, x7);
                u7 = u7 + `pid: ${this.mPid}, tid: ${c8}, name: ${d8}  >>> ${this.mProcessName} <<<\n`;
                w7 = z7.indexOf('#00');
                z7 = z7.substring(w7);
                x7 = z7.indexOf('Tid:') - 1;
                let e8 = z7.substring(0, x7 > 0 ? x7 : undefined);
                let f8 = this.parseBacktrace(e8);
                e8 = e8.split('\n').join('\n\t');
                u7 = u7 + `\nbacktrace:\n\t${e8}`;
                u7 = u7 + '\nbuild id:\n';
                f8.forEach((h8, i8) => {
                    u7 = u7 + `\t${i8} (BuildId: ${h8})\n`;
                });
            }
        }
        catch (b8) {
        }
        FileUtils.write(u7, this.mFile);
    }
    parseBacktrace(f7) {
        let g7 = f7.split('\n');
        let h7 = new HashMap();
        let i7 = new HashMap();
        for (const m7 of g7) {
            if (!m7.includes(' pc ')) {
                continue;
            }
            let n7 = m7.substring(m7.indexOf('/'), m7.indexOf('('));
            let o7 = m7.split('(');
            if (o7.length >= 2) {
                let p7 = o7[0].lastIndexOf('/');
                if (p7 > 0 && p7 + 1 < o7[0].length) {
                    let q7 = o7[0].substring(p7 + 1);
                    if (!h7.hasKey(q7)) {
                        let r7 = o7[o7.length - 1];
                        if (!r7.includes('+')) {
                            let s7 = r7.match('[a-f0-9]+');
                            if (s7 !== null && s7.length == 1) {
                                h7.set(q7, s7[0]);
                                i7.set(n7, s7[0]);
                            }
                        }
                    }
                }
            }
        }
        h7.forEach((k7, l7) => {
            this.mCrashLibs.push(new CrashLib(l7, k7));
        });
        return i7;
    }
    registerFormat(z6) {
        let a7 = z6.split('\n');
        for (let b7 = 0; b7 < a7.length; b7++) {
            if (a7[b7] === '') {
                continue;
            }
            let c7 = a7[b7].split(' ');
            for (let d7 = 0; d7 < c7.length; d7++) {
                let e7 = c7[d7].split(':');
                c7[d7] = e7[0].padEnd(4, ' ') + e7[1];
            }
            a7[b7] = c7.join(' ');
        }
        z6 = a7.join('\n\t');
        return z6;
    }
}
const SignalMap = new Map([
    ["SIGSEGV", 11],
    ["SIGABRT", 6],
    ["SIGBUS", 7],
    ["SIGILL", 4],
    ["SIGTRAP", 5],
    ["SIGFPE", 8],
    ["SIGSYS", 31],
    ["SIGSTKFLT", 16],
]);
const CodeMap = new Map([
    ["SI_USER", 0],
    ["SEGV_MAPERR", 1],
    ["SEGV_ACCERR", 2],
    ["SEGV_BNDERR", 3],
    ["SEGV_PKUERR", 4],
    ["SEGV_MTEAERR", 8],
    ["SEGV_MTESERR", 9],
    ["SI_KERNEL", 128],
    ["SI_QUEUE", -1],
    ["SI_TIMER", -2],
    ["SI_MESGQ", -3],
    ["SI_ASYNCIO", -4],
    ["SI_SIGIO", -5],
    ["SI_TKILL", -6],
    ["SI_DETHREAD", -7],
    ["BUS_ADRALN", 1],
    ["BUS_ADRERR", 2],
    ["BUS_OBJERR", 3],
    ["BUS_MCEERR_AR", 4],
    ["BUS_MCEERR_AO", 5],
    ["ILL_ILLOPC", 1],
    ["ILL_ILLOPN", 2],
    ["ILL_ILLADR", 3],
    ["ILL_ILLTRP", 4],
    ["ILL_PRVOPC", 5],
    ["ILL_PRVREG", 6],
    ["ILL_COPROC", 7],
    ["ILL_BADSTK", 8],
    ["TRAP_BRKPT", 1],
    ["TRAP_TRACE", 2],
    ["TRAP_BRANCH", 3],
    ["TRAP_HWBKPT", 4],
    ["TRAP_UNK", 5],
    ["FPE_INTDIV", 1],
    ["FPE_INTOVF", 2],
    ["FPE_FLTDIV", 3],
    ["FPE_FLTOVF", 4],
    ["FPE_FLTUND", 5],
    ["FPE_FLTRES", 6],
    ["FPE_FLTINV", 7],
    ["FPE_FLTSUB", 8],
    ["SYS_SECCOMP", 1]
]);

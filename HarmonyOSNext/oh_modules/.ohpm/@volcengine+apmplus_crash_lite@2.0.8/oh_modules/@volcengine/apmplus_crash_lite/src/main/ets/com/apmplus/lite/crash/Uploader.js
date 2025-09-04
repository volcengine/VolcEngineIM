import Recorder from './Recorder';
import FaultLogger from "@ohos.faultLogger";
import Header from './protocol/Header';
import Body from './protocol/Body';
import * as Query from './protocol/Query';
import { MultiPartUtility } from '../../../bytedance/hpem/net/MultipartUtility';
import systemDateTime from "@ohos.systemDateTime";
import Folder from './Folder';
import ZipUtils from './utils/ZipUtils';
import { FileUtils } from '../../../bytedance/hpem/util/FileUtils';
import StringUtils from './utils/StringUtils';
import http from '@ohos.net.http';
import { Logger } from './Logger';
export default class Uploader {
    static async start(p11, q11) {
        let r11 = Recorder.getLastUpload(p11, q11.appId);
        let s11 = await FaultLogger.query(FaultLogger.FaultType.JS_CRASH);
        s11.forEach(a12 => {
            Uploader.handle(p11, q11, a12, r11);
        });
        let t11 = await FaultLogger.query(FaultLogger.FaultType.CPP_CRASH);
        t11.forEach(z11 => {
            Uploader.handle(p11, q11, z11, r11);
        });
        let u11 = await FaultLogger.query(FaultLogger.FaultType.APP_FREEZE);
        u11.forEach(y11 => {
            Uploader.handle(p11, q11, y11, r11);
        });
    }
    static handle(b11, c11, d11, e11) {
        if (d11.timestamp > e11 && Uploader.acceptCrash(c11, d11)) {
            let f11 = Header.currentHeader(d11.type, d11.timestamp, c11);
            f11.custom['host_appid'] = c11.hostAppId;
            f11.custom['sdk_version'] = c11.versionName;
            f11.host_app_id = c11.hostAppId;
            if (c11.hostAppId !== undefined && c11.hostAppId !== '') {
                f11.display_name = f11.display_name + `(${c11.hostAppId})`;
            }
            let g11 = new Body(d11.type, f11);
            g11.addFaultLogInfo(b11, c11.appId, d11);
            let h11 = Folder.getCrashDir(b11, c11.appId) + "/" + d11.timestamp;
            let i11 = `${Folder.getTempDir(b11)}/${systemDateTime.getTime()}.zip`;
            ZipUtils.zip(h11, i11, (k11) => {
                if (k11) {
                    try {
                        Uploader.uploadCrash(Uploader.getUploadUrl(c11), g11, i11, 'file', c11, (n11, o11) => {
                            if (o11?.responseCode === http.ResponseCode.OK) {
                                Logger.log('handle upload success.');
                                Recorder.onUpload(b11, c11.appId);
                            }
                            else if (n11) {
                                Logger.log('handle upload failed:' + n11.message);
                            }
                            else {
                                Logger.log('handle upload failed.');
                            }
                            FileUtils.deleteFile(i11);
                        });
                    }
                    catch (l11) {
                        Logger.log('handle upload failed:' + l11.message);
                    }
                }
                FileUtils.deleteDir(h11);
            });
        }
    }
    static acceptCrash(x10, y10) {
        if (y10.type === FaultLogger.FaultType.JS_CRASH) {
            return Uploader.acceptStack(y10.fullLog, x10.packageNames, x10.soList);
        }
        else if (y10.type === FaultLogger.FaultType.APP_FREEZE) {
            let a11 = StringUtils.getStringBetween(y10.fullLog, `Tid:${y10.pid}, Name:`, 'Tid:');
            return Uploader.acceptStack(a11, x10.packageNames, x10.soList);
        }
        else if (y10.type === FaultLogger.FaultType.CPP_CRASH) {
            let z10 = StringUtils.getStringBetween(y10.fullLog, 'Fault thread', 'Registers:', false);
            return Uploader.acceptStack(z10, x10.packageNames, x10.soList);
        }
        return false;
    }
    static acceptStack(s10, t10, u10) {
        for (const w10 of t10) {
            if (s10.includes(w10)) {
                return true;
            }
        }
        for (const v10 of u10) {
            if (s10.includes(v10)) {
                return true;
            }
        }
        return false;
    }
    static uploadCrash(l10, m10, n10, o10, p10, q10) {
        let r10 = new MultiPartUtility(l10, new MultiPartHeader(p10), p10.networkClient);
        r10.addFormField('json', JSON.stringify(m10));
        r10.addFilePart(n10, o10);
        r10.finish(q10);
    }
    static getUploadUrl(k10) {
        return Query.appendQuery(k10.host + "/monitor/collect/c/crash", k10);
    }
}
export class MultiPartHeader {
    constructor(j10) {
        this.boundary = `AAA${systemDateTime.getTime(false)}AAA`;
        this.config = j10;
    }
    getHeader() {
        let h10 = `multipart/form-data; boundary=${this.boundary}`;
        let i10 = new Object();
        i10['Content-Type'] = h10;
        i10['os'] = 'harmony';
        i10['aid'] = this.config.appId;
        i10['x-auth-token'] = this.config.token;
        i10['device_id'] = this.config.deviceId;
        return i10;
    }
    getBoundary() {
        return this.boundary;
    }
}

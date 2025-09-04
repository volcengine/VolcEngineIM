import { AppInfo } from '../../../../bytedance/hpem/util/AppInfo';
const OS_TYPE = '?os=harmony';
const AID = '&aid=';
const DID = '&device_id=';
const VERSION = '&update_version_code=';
const DUMP = '&have_dump=true';
export function appendQuery(r6, s6, t6 = true) {
    let u6 = r6.concat(OS_TYPE);
    try {
        let w6 = s6.versionCode > 0 ? s6.versionCode : AppInfo.version_code;
        u6 = u6.concat(AID)
            .concat(s6.appId)
            .concat(DID)
            .concat(s6.deviceId)
            .concat(VERSION)
            + w6;
    }
    catch (v6) {
    }
    if (t6) {
        u6 = u6.concat(DUMP);
    }
    return u6;
}

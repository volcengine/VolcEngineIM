const CRASH_TYPE = ["no_specific", "unknown", "cpp_crash", "js_crash", "app_freeze"];
export function getCrashType(r5) {
    if (r5 >= CRASH_TYPE.length || r5 < 0) {
        return CRASH_TYPE[1];
    }
    return CRASH_TYPE[r5];
}

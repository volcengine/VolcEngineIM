package com.bytedance.im.ui.log;

import android.util.Log;

public class BIMLog {
    public static final String PREFIX = "[imsdk_ui]";

    public static int i(String tag, String msg) {
        return Log.i(tag, msg);
    }

    public static int d(String tag, String msg) {
        return Log.d(tag, msg);
    }

    public static int w(String tag, String msg) {
        return Log.w(tag, msg);
    }
    public static int e(String tag, String msg) {
        return Log.e(tag, msg);
    }
}

package com.bytedance.im.veapp;

import android.util.Log;

import androidx.multidex.MultiDexApplication;

import com.bytedance.im.core.BuildConfig;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.ui.BIMUIClient;

/**
 * veapp 模块仅是壳工程，便于 imapp 模块作为 lib 提供 vevos 联合demo 开发使用。
 * 不要在此模块做任何业务逻辑
 */
public class VEIMApplication extends MultiDexApplication {
    private static final String TAG = "VEIMApplication";
    //VEDefaultAccountProvider
    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "BuildConfig.DEBUG: " + BuildConfig.DEBUG);
        Log.i(TAG, "uikit version: " + BIMUIClient.getInstance().getVersion());
        Log.i(TAG, "imSdk version: " + BIMClient.getInstance().getVersion());
    }
}


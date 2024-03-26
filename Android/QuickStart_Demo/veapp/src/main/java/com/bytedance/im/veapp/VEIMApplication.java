package com.bytedance.im.veapp;

import android.util.Log;

import androidx.multidex.MultiDexApplication;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.ui.BIMUIClient;


public class VEIMApplication extends MultiDexApplication {
    private static final String TAG = "VEIMApplication";
    //VEDefaultAccountProvider
    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "uikit version: " + BIMUIClient.getInstance().getVersion());
        Log.i(TAG, "imSdk version: " + BIMClient.getInstance().getVersion());
    }
}


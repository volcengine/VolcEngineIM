package com.bytedance.im.app;

import android.app.Application;
import android.support.multidex.MultiDexApplication;
import android.util.Log;

import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.interfaces.BIMAccountProvider;

import com.bytedance.im.app.user.VEDefaultAccountProvider;
import com.bytedance.im.ui.BIMUIClient;

public class VEIMApplication extends MultiDexApplication {
    private static final String TAG = "VEIMApplication";
    //VEDefaultAccountProvider
    public static final BIMAccountProvider accountProvider = new VEDefaultAccountProvider();
    @Override
    public void onCreate() {
        super.onCreate();
        SpUtils.getInstance().init(this);   //初始化sp
        Log.i(TAG, "uikit version: " + BIMUIClient.getInstance().getVersion());
        Log.i(TAG, "imSdk version: " + BIMClient.getInstance().getVersion());
    }
}

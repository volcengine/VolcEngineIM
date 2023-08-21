package com.bytedance.im.app;

import android.app.Application;
import android.util.Log;

import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.sysbug.PreventProcessKill;
import com.bytedance.im.app.user.VEDefaultAccountProvider;
import com.bytedance.im.core.api.model.BIMSDKConfig;
import com.bytedance.im.interfaces.BIMAccountProvider;

import com.bytedance.im.ui.BIMUIClient;

public class VEIMApplication extends Application {
    private static final String TAG = "VEIMApplication";
    //VEDefaultAccountProvider
    public static final BIMAccountProvider accountProvider = new VEDefaultAccountProvider();

    @Override
    public void onCreate() {
        super.onCreate();
        SpUtils.getInstance().init(this);   //初始化sp
    }
}

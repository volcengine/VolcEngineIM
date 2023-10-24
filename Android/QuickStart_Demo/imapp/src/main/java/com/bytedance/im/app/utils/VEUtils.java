package com.bytedance.im.app.utils;

import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.bytedance.im.app.BuildConfig;
import com.bytedance.im.app.VEIMApplication;
import com.bytedance.im.app.login.VELoginActivity;
import com.bytedance.im.app.user.VEDefaultAccountProvider;

public class VEUtils {

    public static void reStarApp(Context context) {
        Toast.makeText(context, "重启应用！", Toast.LENGTH_SHORT).show();
        android.os.Process.killProcess(android.os.Process.myPid());
    }

    //实验功能，暂时屏蔽
    public static boolean isShield() {
        return !BuildConfig.DEBUG || VEIMApplication.accountProvider instanceof VEDefaultAccountProvider;
    }
}

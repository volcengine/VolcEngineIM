package com.bytedance.im.app.utils;

import android.content.Context;
import android.content.Intent;

import com.bytedance.im.app.login.VELoginActivity;

public class VEUtils {

    public static void reStarApp(Context context) {
        Intent intent = new Intent(context, VELoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
        android.os.Process.killProcess(android.os.Process.myPid());
    }
}

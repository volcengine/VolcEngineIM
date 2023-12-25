package com.bytedance.im.ui.utils;

import android.app.ActivityManager;
import android.content.Context;
import android.os.Looper;
import android.text.TextUtils;

import com.bytedance.im.ui.api.BIMUIUser;

public class BIMUIUtils {
    public static int dpToPx(Context context, float dps) {
        return Math.round(context.getResources().getDisplayMetrics().density * dps);
    }
    public static boolean isMainProcess(Context context){
        return context.getApplicationContext().getPackageName().equals(getCurrentProcessName(context));
    }

    public static boolean isMainThread(){
        return Looper.getMainLooper() == Looper.myLooper();
    }

    public static String getCurrentProcessName(Context context) {
        int pid = android.os.Process.myPid();
        String processName = "";
        ActivityManager manager = (ActivityManager) context.getApplicationContext().getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningAppProcessInfo process : manager.getRunningAppProcesses()) {
            if (process.pid == pid) {
                processName = process.processName;
            }
        }
        return processName;
    }


    public static String getShowName(BIMUIUser bimuiUser) {
        String name = "用户" + bimuiUser.getUid();         //用户ID
        if (!TextUtils.isEmpty(bimuiUser.getNickName())) { //用户资料名
            name = bimuiUser.getNickName();
        }
        if (!TextUtils.isEmpty(bimuiUser.getMemberAlias())) {
            name = bimuiUser.getMemberAlias();             //群内备注
        }
        if (!TextUtils.isEmpty(bimuiUser.getAlias())) {  //好友备注名
            name = bimuiUser.getAlias();
        }
        return name;
    }
}

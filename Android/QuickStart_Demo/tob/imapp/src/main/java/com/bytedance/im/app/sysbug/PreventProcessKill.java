package com.bytedance.im.app.sysbug;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.bytedance.im.app.in.login.VELoginActivity;
import com.bytedance.im.ui.utils.BIMUIUtils;

/**
 * 应用运行过程中会收回权限导致应用被系统重启的问题
 */
public class PreventProcessKill implements Application.ActivityLifecycleCallbacks {
    private static final String TAG = "PreventProcessKill";
    private int activityCount = 0;
    private boolean isErrorRobot = true;

    public static void registerApplication(Application application) {
        if (BIMUIUtils.isMainProcess(application)) {
            application.registerActivityLifecycleCallbacks(new PreventProcessKill());
        }
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        if (activity instanceof VELoginActivity && activityCount == 0 && activity.isTaskRoot()) {
            isErrorRobot = false;
        }

        if (isErrorRobot) {
            Log.e(TAG, "error reboot need reboot App fix!");
            Intent intent = new Intent(activity, VELoginActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            activity.startActivity(intent);
            activity.overridePendingTransition(0, 0);
            activity.finish();
        }
    }

    @Override
    public void onActivityStarted(Activity activity) {
        activityCount++;
    }

    @Override
    public void onActivityResumed(Activity activity) {

    }

    @Override
    public void onActivityPaused(Activity activity) {

    }

    @Override
    public void onActivityStopped(Activity activity) {
        activityCount--;
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }
}

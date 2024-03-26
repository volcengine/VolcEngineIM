package com.bytedance.im.ui.utils;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import android.text.TextUtils;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class BIMPermissionController {

    public interface IPermissionReqListener {
        /**
         * 多条权限申请回调
         */
        void onPermissionRequest(boolean isAllGranted, @NonNull String[] permissions, int[] grantResults);
    }

    // FragmentActivity要求request code为8位
    private static int sIncRequestCode = 0;

    private static Map<Integer, IPermissionReqListener> mListenerMap = new HashMap<>();

    public static void dispatchPermissionResult(Activity activity, int requestCode, @NonNull String[] permissions,
                                                @NonNull int[] grantResults) {
        if (permissions.length == 0 || grantResults.length == 0) {
            return;
        }
        for (int index = 0; index < permissions.length; index++) {
            if (grantResults[index] != PackageManager.PERMISSION_GRANTED) {
                if (!ActivityCompat.shouldShowRequestPermissionRationale(activity, permissions[index])) {
                    //用户之前拒绝，并勾选不再提示时，引导用户去设置页面开启权限
                    showGrantToast(activity.getApplicationContext(), permissions[index]);
                }
            }
        }
        IPermissionReqListener listener = mListenerMap.get(requestCode);
        if (listener != null) {

            boolean isAllGranted = true;
            for (int grant : grantResults) {
                if (grant != PackageManager.PERMISSION_GRANTED) {
                    isAllGranted = false;
                    listener.onPermissionRequest(false, permissions, grantResults);
                    break;
                }
            }
            if (isAllGranted) {
                listener.onPermissionRequest(true, permissions, grantResults);
            }
            mListenerMap.remove(requestCode);
        }
    }

    public static void checkPermission(Activity activity, String permission, IPermissionReqListener listener) {
        checkPermission(activity, new String[]{permission}, listener);
    }

    public static void checkPermission(Activity activity, String[] permissions, IPermissionReqListener listener) {
        if (activity == null || permissions == null || permissions.length <= 0) {
            return;
        }
        List<String> unauthorizedPermissions = new ArrayList<>();
        for (String permission : permissions) {
            if (TextUtils.isEmpty(permission)) {
                continue;
            }
            try {
                if (ContextCompat.checkSelfPermission(activity, permission) != PackageManager.PERMISSION_GRANTED) {
                    unauthorizedPermissions.add(permission);
                } else {
                }
            } catch (Exception e) {
                unauthorizedPermissions.add(permission);
            }
        }
        if (!unauthorizedPermissions.isEmpty()) {
            sIncRequestCode++;
            if (sIncRequestCode > 255) {
                sIncRequestCode = 0;
            }
            mListenerMap.put(sIncRequestCode, listener);
            ActivityCompat
                    .requestPermissions(activity, unauthorizedPermissions.toArray(new String[unauthorizedPermissions.size()]),
                            sIncRequestCode);
        } else {
            if (listener != null) {
                int[] result = new int[permissions.length];
                listener.onPermissionRequest(true, permissions, result);
            }
        }
    }


    public static void showGrantToast(Context context, String unauthorizedPermission) {
        if (TextUtils.isEmpty(unauthorizedPermission)) {
            return;
        }
        if (Manifest.permission.WRITE_EXTERNAL_STORAGE.equals(unauthorizedPermission) ||
                Manifest.permission.READ_EXTERNAL_STORAGE.equals(unauthorizedPermission)) {
            Toast.makeText(context, "请到设置中开启存储权限", Toast.LENGTH_SHORT).show();
        }
    }

    public static boolean hasPermission(Context context, String permission) {
        if (context == null || permission == null) {
            return false;
        }
        return ContextCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED;
    }

    public static boolean hasPermission(Context context, String[] permissions) {
        if (context == null || permissions == null) {
            return false;
        }
        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }
}

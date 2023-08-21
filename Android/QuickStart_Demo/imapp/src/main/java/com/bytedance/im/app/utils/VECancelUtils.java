package com.bytedance.im.app.utils;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.FrameLayout;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.VEIMApplication;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.ui.api.interfaces.BIMCancelListener;

public class VECancelUtils {
    public static String TAG = "VECancelUtils";

    public static void showCancelDialog(Context context, CancelAccountCallback callback) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setCancelable(false);
        builder.setMessage(R.string.unregister_description);
        builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                doCancel(context, callback);
            }
        });
        builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
            }
        });
        AlertDialog alertDialog = builder.create();
        alertDialog.show();
    }

    private static void doCancel(Context context, CancelAccountCallback callback) {
        AlertDialog dialog = new AlertDialog.Builder(context).create();
        dialog.setCancelable(false);
        dialog.show();

        Window window = dialog.getWindow();
        if (null != window) {
            window.setGravity(Gravity.CENTER);
            window.setContentView(R.layout.ve_im_layout_progress);
            window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        }

        VEIMApplication.accountProvider.unregister(new BIMCancelListener() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "delete account success");
                SpUtils.getInstance().setLoginUserInfo(null);
                callback.onLogout();
                dialog.dismiss();
            }

            @Override
            public void onFailed(int errCode, String errMsg) {
                Log.e(TAG, "delete account failed, code " + errCode + ", msg: " + errMsg);
                Toast.makeText(context, "注销失败", Toast.LENGTH_SHORT).show();
                dialog.dismiss();
            }
        }, 60 * 1000);
    }

    public interface CancelAccountCallback {
        void onLogout();
    }
}

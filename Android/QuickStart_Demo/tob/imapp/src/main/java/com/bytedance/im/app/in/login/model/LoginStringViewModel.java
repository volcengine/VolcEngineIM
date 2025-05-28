package com.bytedance.im.app.in.login.model;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.main.VEIMMainActivity;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.ui.BIMUIClient;

public class LoginStringViewModel {
    private static final String TAG = "LoginStringViewModel";
    private Activity activity;

    public LoginStringViewModel(Activity activity) {
        this.activity = activity;
    }

    public void onProtoAgree(String uid, String token) {
        //同意协议,后初始化sdk
        Log.i(TAG, "onProtoAgree()");
        UserStrToken userStrToken = SpUtils.getInstance().getLoginUserStrInfo(); //缓存登录
        if (userStrToken != null) {
            loginIM(userStrToken.getUidStr(), userStrToken.getToken());
        }
    }

    public void initIM(){
        IMInitUtils.initIM(activity.getApplication());
    }


    public void loginIM(String uidStr, String token) {
        Log.i(TAG, "loginIM uidStr:" + uidStr + " token:" + token);
        BIMUIClient.getInstance().login(uidStr, token, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "login success()");
                SpUtils.getInstance().setLoginUserStrInfo(new UserStrToken(BIMClient.getInstance().getAppID(), uidStr, token));
                Toast.makeText(activity, "登录成功", Toast.LENGTH_SHORT).show();
                VEIMMainActivity.start(activity);
                activity.finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "login failed() code:" + code + " msg:" + code.getDesc());
                Toast.makeText(activity, "登录失败", Toast.LENGTH_SHORT).show();
            }
        });

    }
}

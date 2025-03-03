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

public class LoginLongViewModel {
    private static final String TAG = "LoginLongViewModel";
    private Activity activity;

    public LoginLongViewModel(Activity activity) {
        this.activity = activity;
    }

    public void onProtoAgree(boolean forceUserCacheLogin, long uid, String token) {
        //同意协议,后初始化sdk
        UserToken userToken = SpUtils.getInstance().getLoginUserInfo();
        Log.i(TAG, "onProtoAgree() userToken:" + userToken);
        if (forceUserCacheLogin) {
            //如果登录过直接登录
            if (userToken != null) {
                loginIM(userToken.getUid(), userToken.getToken());
            }
        } else {
            //和上次比对
            if (userToken != null
                    && userToken.getAppId() == BIMClient.getInstance().getAppID()
                    && userToken.getToken().equals(token)
                    && uid == userToken.getUid()) {
                loginIM(userToken.getUid(), userToken.getToken());
            }
        }
    }

    public void initIM() {
        IMInitUtils.initIM(activity.getApplication());
    }


    /**
     * 登陆 IMSDK
     *
     * @param uid
     * @param token
     */
    public void loginIM(long uid, String token) {
        Log.i(TAG, "loginIM uid:" + uid + " token:" + token);
        BIMUIClient.getInstance().login(uid, token, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "login success()");
                SpUtils.getInstance().setLoginUserInfo(new UserToken(BIMClient.getInstance().getAppID(), uid, token));
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

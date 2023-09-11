package com.bytedance.im.app.login;

import android.app.Activity;
import android.app.Application;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.VEIMApplication;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.debug.VEEnvSettingActivity;
import com.bytedance.im.app.main.VEIMMainActivity;
import com.bytedance.im.app.sysbug.PreventProcessKill;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.model.BIMSDKConfig;
import com.bytedance.im.interfaces.BIMAuthProvider;
import com.bytedance.im.interfaces.BIMLoginListener;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.app.login.model.UserToken;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;

public class VELoginActivity extends Activity implements BIMLoginListener {
    private static final String TAG = "VELoginActivity";

    private Fragment loginFragment;
    private int toDebugCount = 0;

    public static void start(Context context) {
        Intent intent = new Intent(context, VELoginActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_login);
        initLoginFragment();
    }

    private void initLoginFragment() {
        FragmentManager fm = getFragmentManager();
        FragmentTransaction ft = fm.beginTransaction();
        if (loginFragment == null) {
            loginFragment = VEIMApplication.accountProvider.createLoginFragment();
            if (loginFragment instanceof BIMAuthProvider) {
                BIMAuthProvider provider = (BIMAuthProvider) loginFragment;
                provider.setLoginListener(this);
            }
        }
        ft.add(R.id.fl_content, loginFragment);
        ft.show(loginFragment);
        ft.commitAllowingStateLoss();
    }

    /**
     *  点击同意弹窗
     */
    @Override
    public void onProtoAgree() {
        //同意协议,后初始化sdk
        Log.i(TAG,"onProtoAgree()");
        init(getApplication());
        //如果登录过直接登录
        UserToken userToken = SpUtils.getInstance().getLoginUserInfo();
        if (userToken != null) {
            loginIM(userToken.getUid(), userToken.getName(), userToken.getToken());
        }
    }

    /**
     * 点击登录按钮
     * @param user
     * @param token
     */
    @Override
    public void doLogin(BIMUser user, String token) {
        Log.i(TAG, "doLogin() uid: " + user.getUserID() + " token:" + token);
        loginIM(user.getUserID(), user.getNickName(), token);
    }

    @Override
    public void onDebugClick() {
        toDebugCount++;
        if (toDebugCount == 3) {
            VEEnvSettingActivity.start(this);
            toDebugCount = 0;
        }
    }

    /**
     * 登陆 IMSDK
     *
     * @param uid
     * @param name
     * @param token
     */
    private void loginIM(long uid, String name, String token) {
        Log.i(TAG, "loginIM uid:" + uid + " token:" + token);
        BIMUIClient.getInstance().login(uid, token, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "login success()");
                SpUtils.getInstance().setLoginUserInfo(new UserToken(uid, name, token));
                Toast.makeText(VELoginActivity.this, "登录成功", Toast.LENGTH_SHORT).show();
                VEIMMainActivity.start(VELoginActivity.this);
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "login failed() code:" + code + " msg:" + code.getDesc());
                Toast.makeText(VELoginActivity.this, "登录失败", Toast.LENGTH_SHORT).show();
            }
        });
    }

    /**
     * 初始化
     * @param application
     */
    public void init(Application application) {
        Log.i(TAG,"initSDK()");
        //imsdk
        int env = SpUtils.getInstance().getEnv();
        String swimLean = "";
        if (env == Constants.ENV_BOE) {
            swimLean = SpUtils.getInstance().getBoeSwimLane();
        } else if (env == Constants.ENV_PPE) {
            swimLean = SpUtils.getInstance().getPpeSwimLane();
        }
        BIMUIClient.getInstance().init(application, Constants.APP_ID, env, swimLean, null);
        VEIMApplication.accountProvider.init(application, Constants.APP_ID, SpUtils.getInstance().getEnv());
        BIMUIClient.getInstance().setUserProvider(VEIMApplication.accountProvider.getUserProvider());
    }
}

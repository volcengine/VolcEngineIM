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
import com.bytedance.im.app.user.provider.BIMDefaultUserProvider;
import com.bytedance.im.app.utils.VEUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.model.BIMSDKConfig;
import com.bytedance.im.interfaces.BIMAuthProvider;
import com.bytedance.im.interfaces.BIMLoginListener;
import com.bytedance.im.ui.BIMUIClient;
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
        ft.replace(R.id.fl_content,loginFragment);
        ft.commitAllowingStateLoss();
    }

    /**
     *  点击同意弹窗
     * @param forceUserCacheLogin  //本地存在token是否需要校验 uid
     */
    @Override
    public void onProtoAgree(boolean forceUserCacheLogin, long uid, String token) {
        //同意协议,后初始化sdk
        Log.i(TAG,"onProtoAgree()");
        init(Constants.APP_ID,getApplication());
        UserToken userToken = SpUtils.getInstance().getLoginUserInfo();
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

    /**
     * 点击登录按钮
     * @param user
     * @param token
     */
    @Override
    public void doLogin(long uid, String token) {
        Log.i(TAG, "doLogin() uid: " + uid + " token:" + token);
        loginIM(uid, token);
    }

    @Override
    public void onDebugClick() {
        toDebugCount++;
        if (toDebugCount == 3 ) {
            if (!VEUtils.isShield()) {    //屏蔽掉 debug 入口
                VEEnvSettingActivity.start(this);
            }
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
    private void loginIM(long uid, String token) {
        Log.i(TAG, "loginIM uid:" + uid + " token:" + token);
        BIMUIClient.getInstance().login(uid, token, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "login success()");
                SpUtils.getInstance().setLoginUserInfo(new UserToken(BIMClient.getInstance().getAppID(), uid, token));
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
    public void init(int appId,Application application) {
        Log.i(TAG,"initSDK()");
        //imsdk
        int env = SpUtils.getInstance().getEnv();
        String swimLean = "";
        if (env == Constants.ENV_BOE) {
            swimLean = SpUtils.getInstance().getBoeSwimLane();
        } else if (env == Constants.ENV_PPE) {
            swimLean = SpUtils.getInstance().getPpeSwimLane();
        }

        BIMSDKConfig config = new BIMSDKConfig();
        config.setEnableAPM(SpUtils.getInstance().isEnableAPM());
        config.setEnableAppLog(SpUtils.getInstance().isEnableALog());
        BIMUIClient.getInstance().init(application,appId, env, swimLean, config);
        VEIMApplication.accountProvider.init(application, Constants.APP_ID, SpUtils.getInstance().getEnv());
        BIMUIClient.getInstance().setUserProvider(new BIMDefaultUserProvider(500));
    }
}

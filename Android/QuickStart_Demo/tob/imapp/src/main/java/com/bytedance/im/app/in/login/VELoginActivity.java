package com.bytedance.im.app.in.login;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.debug.VEEnvSettingActivity;
import com.bytedance.im.app.in.login.model.LoginLongViewModel;
import com.bytedance.im.app.in.login.model.LoginStringViewModel;
import com.bytedance.im.app.main.VEIMMainActivity;
import com.bytedance.im.app.uidstr.VEUidStringAccountProvider;
import com.bytedance.im.app.utils.VEUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.ui.api.interfaces.BIMAuthProvider;
import com.bytedance.im.ui.api.interfaces.BIMLoginListener;
import com.bytedance.im.ui.api.interfaces.BIMUidStrLoginListener;

public class VELoginActivity extends Activity {
    private static final String TAG = "VELoginActivity_IM";

    private Fragment loginFragment;
    private int toDebugCount = 0;
    private LoginLongViewModel loginLongViewModel;
    private LoginStringViewModel loginStringViewModel;

    public static void start(Context context) {
        Intent intent = new Intent(context, VELoginActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SpUtils.getInstance().init(this);   //初始化sp
        if (SpUtils.getInstance().isEnableDebugLogin()) { //字符串Uid登录
            Log.i(TAG, "onCreate() 使用字符串登录");
            Constants.accountProvider = new VEUidStringAccountProvider();
            loginStringViewModel = new LoginStringViewModel(this);
        }
        loginLongViewModel = new LoginLongViewModel(this);
        if (BIMClient.getInstance().getCurrentUserID() <= 0) { //未登录账号
            setContentView(R.layout.ve_im_activity_login);
            initLoginFragment();
        } else {
            VEIMMainActivity.start(VELoginActivity.this);
            finish();
        }
    }

    private void initLoginFragment() {
        FragmentManager fm = getFragmentManager();
        FragmentTransaction ft = fm.beginTransaction();
        if (loginFragment == null) {
            loginFragment = Constants.accountProvider.createLoginFragment();
            if (loginFragment instanceof BIMAuthProvider) {
                BIMAuthProvider provider = (BIMAuthProvider) loginFragment;
                initLoginByStringUid(provider);
                initLoginByLongUid(provider);
            }
        }
        ft.replace(R.id.fl_content, loginFragment);
        ft.commitAllowingStateLoss();
    }

    //long 型 uid 登录流程
    private void initLoginByLongUid(BIMAuthProvider provider) {
        provider.setLoginListener(new BIMLoginListener() {
            @Override
            public void onProtoAgree(boolean forceUserCacheLogin, long uid, String token) {
                loginLongViewModel.onProtoAgree(forceUserCacheLogin, uid, token);
            }

            @Override
            public void doInit() {
                loginLongViewModel.initIM();
            }

            @Override
            public void doLogin(long uid, String token) {
                loginLongViewModel.loginIM(uid, token);
            }

            @Override
            public void onDebugClick() {
                checkToDebug();
            }
        });
    }

    //string 型 uid 登录流程
    private void initLoginByStringUid(BIMAuthProvider provider) {
        provider.setLoginUidStrListener(new BIMUidStrLoginListener() {
            @Override
            public void onProtoAgree(String uidStr, String token) {
                loginStringViewModel.onProtoAgree(uidStr, token);
            }

            @Override
            public void doInit() {
                loginStringViewModel.initIM();
            }

            @Override
            public void doLogin(String uidStr, String token) {
                loginStringViewModel.loginIM(uidStr, token);
            }

            @Override
            public void onDebugClick() {
                checkToDebug();
            }
        });
    }

    private void checkToDebug() {
        toDebugCount++;
        if (toDebugCount == 3) {
            if (!VEUtils.isShield()) {    //屏蔽掉 debug 入口
                VEEnvSettingActivity.start(this);
            }
            toDebugCount = 0;
        }
    }
}

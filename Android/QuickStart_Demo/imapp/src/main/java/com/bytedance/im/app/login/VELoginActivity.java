package com.bytedance.im.app.login;

import android.app.Activity;
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
import com.bytedance.im.app.main.VEIMMainActivity;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.interfaces.BIMAuthProvider;
import com.bytedance.im.interfaces.BIMLoginListener;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.app.login.model.UserToken;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;

public class VELoginActivity extends Activity implements BIMLoginListener {
    private static final String TAG = "VELoginActivity";

    private Fragment loginFragment;

    public static void start(Context context) {
        Intent intent = new Intent(context, VELoginActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_login);
        UserToken userToken = SpUtils.getInstance().getLoginUserInfo();
        if (userToken != null) {
            loginIM(userToken.getUid(), userToken.getName(), userToken.getToken());
        }
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

    @Override
    public void doLogin(BIMUser user, String token) {
        Log.i(TAG, "doLogin() uid: " + user.getUserID() + " token:" + token);
        loginIM(user.getUserID(), user.getNickName(), token);
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

    private void loginIM(BIMUser user, String token) {
        loginIM(user.getUserID(), user.getNickName(), token);
    }
}

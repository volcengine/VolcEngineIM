package com.bytedance.im.app.in.login;

import android.app.Activity;
import android.app.Application;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.util.Log;
import android.widget.Toast;

import com.bytedance.im.app.BIMDefaultUserProvider;
import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.custom.data.BIMCouponElement;
import com.bytedance.im.app.custom.data.BIMP2PTypingElement;
import com.bytedance.im.app.custom.toolbtn.CouponToolBtn;
import com.bytedance.im.app.custom.ui.BIMCouponMessageUI;
import com.bytedance.im.app.debug.VEEnvSettingActivity;
import com.bytedance.im.app.main.VEIMMainActivity;
import com.bytedance.im.app.custom.operations.VEMessageDetailOperationInfo;
import com.bytedance.im.app.utils.VEUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.model.BIMSDKConfig;

import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.app.in.login.model.UserToken;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.ui.api.interfaces.BIMAuthProvider;
import com.bytedance.im.ui.api.interfaces.BIMLoginListener;

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
        if (BIMClient.getInstance().getCurrentUserID() <=0) { //未登录账号
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
        init(getApplication());
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
    private static boolean isInit = false;
    public void init(Application application) {
        if(isInit){
            Log.i(TAG, "login init() already init return !");
            return;
        }
        isInit = true;
        SpUtils.getInstance().init(this);   //初始化sp
        //imsdk
        if (Constants.APP_ENV != -1) {  //以代码配置为准
            SpUtils.getInstance().setEnv(Constants.APP_ENV);
        }
        int env = SpUtils.getInstance().getEnv();
        int curAppId = Constants.APP_ID;
        String swimLean = "";
        if (env == Constants.ENV_i18n) {
            curAppId = Constants.APP_ID_I18N;  //海外 appid
        } else if (env == Constants.ENV_DEFAULT) {
            curAppId = Constants.APP_ID;    //国内 appid
        } else if (env == Constants.ENV_PPE) {
            swimLean = SpUtils.getInstance().getPpeSwimLane();
        }

        Log.i(TAG, "initSDK() env: " + env + " curAppId: " + curAppId);
        BIMSDKConfig config = new BIMSDKConfig();
        config.setEnableAPM(SpUtils.getInstance().isEnableAPM());
        config.setEnableAppLog(SpUtils.getInstance().isEnableALog());
        initCustom();
        BIMUIClient.getInstance().setUserProvider(new BIMDefaultUserProvider(500)); //需要先设置
        BIMUIClient.getInstance().init(application,curAppId, env, swimLean, config);
        Constants.accountProvider.init(application, curAppId, env);
        BIMUIClient.getInstance().setUserExistChecker(Constants.accountProvider.createUserExistChecker());
    }


    private void initCustom(){
            initCustomMessageList();
            initMessageOperationList();
            initToolBtnList();
    }

    //自定义消息
    private void initCustomMessageList(){
        BIMUIClient.getInstance().registerMessageUI(new BIMCouponMessageUI());
        BIMUIClient.getInstance().registerMessageElement("3", BIMCouponElement.class);
        BIMUIClient.getInstance().registerMessageElement("1000", BIMP2PTypingElement.class);
    }
    //长按消息操作
    private void initMessageOperationList(){
        if (!VEUtils.isShield()) {  //查看消息详情， debug 功能屏蔽
            BIMUIClient.getInstance().registerMessageOperation(new VEMessageDetailOperationInfo());
        }
    }
    //输入工具栏
    private void initToolBtnList(){
        BIMUIClient.getInstance().registerToolBtn(new CouponToolBtn());
    }
}

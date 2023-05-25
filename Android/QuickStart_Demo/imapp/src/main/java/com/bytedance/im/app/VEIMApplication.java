package com.bytedance.im.app;

import android.app.Application;
import android.util.Log;

import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.login.data.UserMock;
import com.bytedance.im.app.login.net.HttpClient;
import com.bytedance.im.app.sysbug.PreventProcessKill;
import com.bytedance.im.core.api.enums.BIMLogLevel;
import com.bytedance.im.core.api.interfaces.BIMLogListener;
import com.bytedance.im.core.api.model.BIMSDKConfig;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.user.BIMUser;
import com.bytedance.im.ui.user.UserProvider;

import java.util.List;

public class VEIMApplication extends Application {
    private static final String TAG = "VEIMApplication";
    public static final int APP_ID = 0;
    @Override
    public void onCreate() {
        super.onCreate();
        SpUtils.getInstance().init(this);   //初始化sp
        HttpClient.getInstance().init(this);//初始化网络库
        init();
        PreventProcessKill.registerApplication(this);
    }


    private void init() {
        BIMSDKConfig config = new BIMSDKConfig();
        config.setLogListener(new BIMLogListener() {
            @Override
            public void onLog(BIMLogLevel logLevel, String content) {
                Log.i("imsdk", content);
            }
        });
        int env = SpUtils.getInstance().getEnv();
        String swimLean = "";
        if (env == Constants.ENV_BOE) {
            swimLean = SpUtils.getInstance().getBoeSwimLane();
        } else if (env == Constants.ENV_PPE) {
            swimLean = SpUtils.getInstance().getPpeSwimLane();
        }
        BIMUIClient.getInstance().init(this, APP_ID, env, swimLean, config);
        BIMUIClient.getInstance().setUserProvider(new UserProvider() {
            @Override
            public BIMUser getUserInfo(long uid) {
                return UserMock.getInstance().getUserInfo(uid);
            }

            @Override
            public List<BIMUser> getAllUserInfo() {
                return UserMock.getInstance().getMockLoginUserList();
            }
        });
    }
}

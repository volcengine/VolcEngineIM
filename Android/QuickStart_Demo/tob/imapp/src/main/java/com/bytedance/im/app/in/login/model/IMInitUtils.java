package com.bytedance.im.app.in.login.model;

import android.app.Application;
import android.util.Log;

import com.bytedance.im.app.BIMDefaultUserProvider;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.custom.data.BIMCouponElement;
import com.bytedance.im.app.custom.data.BIMP2PTypingElement;
import com.bytedance.im.app.custom.operations.VEMessageDetailOperationInfo;
import com.bytedance.im.app.custom.operations.VEUnreadMessageDetailOperationInfo;
import com.bytedance.im.app.custom.toolbtn.CouponToolBtn;
import com.bytedance.im.app.custom.ui.BIMCouponMessageUI;
import com.bytedance.im.app.utils.VEUtils;
import com.bytedance.im.core.api.model.BIMSDKConfig;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.interfaces.BIMFilterToolBtnInterceptor;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.VideoToolBtnV2;
import com.bytedance.im.ui.utils.BIMUtils;

import java.util.Iterator;
import java.util.List;

public class IMInitUtils {
    private static final String TAG = "IMInitUtils";

    /**
     * 初始化
     *
     * @param application
     */
    public static boolean isInit = false;

    public static void initIM(Application application) {
        Log.i(TAG, "IMInitUtilsInitIM() start");
        if (isInit) {
            Log.i(TAG, "login init() already init return !");
            return;
        }
        isInit = true;
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
        } else if (env == Constants.ENV_PPEi18n) {
            curAppId = Constants.APP_ID_I18N;
            swimLean = SpUtils.getInstance().getI18NPpeSwimLane();
        }

        Log.i(TAG, "initSDK() env: " + env + " curAppId: " + curAppId);
        BIMSDKConfig config = new BIMSDKConfig();
        config.setEnableAPM(SpUtils.getInstance().isEnableAPM());
        config.setEnableAppLog(SpUtils.getInstance().isEnableALog());
//        config.setLogListener(new BIMLogListener() {
//            @Override
//            public void onLog(BIMLogLevel logLevel, String content) {
//                Log.i("customLog","content: "+content);
//            }
//        });
        //自定义消息
        BIMUIClient.getInstance().registerMessageUI(new BIMCouponMessageUI());
        BIMUIClient.getInstance().registerMessageElement("3", BIMCouponElement.class);
        BIMUIClient.getInstance().registerMessageElement("1000", BIMP2PTypingElement.class);
        //长按消息操作
        if (!VEUtils.isShield()) {  //查看消息详情， debug 功能屏蔽
            BIMUIClient.getInstance().registerMessageOperation(new VEMessageDetailOperationInfo());
            BIMUIClient.getInstance().registerMessageOperation(new VEUnreadMessageDetailOperationInfo());
        }
        //输入工具栏
        BIMUIClient.getInstance().registerToolBtn(new CouponToolBtn()); //优惠券
        BIMUIClient.getInstance().setUserProvider(new BIMDefaultUserProvider(500)); //需要先设置
        BIMUIClient.getInstance().setToolBtnInterceptor(toolBtnList -> {
            Iterator<BaseToolBtn> iterator = toolBtnList.iterator();
            while (iterator.hasNext()) {
                BaseToolBtn btn = iterator.next();
                if (VEUtils.isShield() && (btn instanceof VideoToolBtnV2)) {
                    iterator.remove();
                }
            }

            return toolBtnList;
        });

        BIMUIClient.getInstance().init(application, curAppId, env, swimLean, config);

        Constants.accountProvider.init(application, curAppId, env);
        BIMUIClient.getInstance().setUserExistChecker(Constants.accountProvider.createUserExistChecker());
    }
}

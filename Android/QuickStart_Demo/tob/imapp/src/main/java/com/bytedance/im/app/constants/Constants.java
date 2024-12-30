package com.bytedance.im.app.constants;


import com.bytedance.im.ui.api.interfaces.BIMAccountProvider;
import com.bytedance.im.app.VEDefaultAccountProvider;
public class Constants {

    public static final int APP_ID = 0; //国内appID

    public static final String token = "4PSUAb9wRtD315bnH2UBMnlh7jNfm7rao0i4jHfaqu2iFfLm79pgW5";  //token

    public static final long uid = 2544733918335184L;      //用户uid


    /**
     * 海外环境配置
     */
    public static final int APP_ID_I18N = 0;//海外appID
    public static final int APP_ENV = Constants.ENV_DEFAULT;   //海外需要配置为 ENV_i18n //国内配置为 ENV_RELEASE

    /**
     * 线上环境
     */
    public static final int ENV_RELEASE = 0;
    /**
     * ppe环境
     */
    public static final int ENV_PPE = 2;
    /**
     * boe环境
     */
    public static final int ENV_BOE = 3;
    /**
     * boe环境，不带泳道，跟 boe 的域名不同
     */
    public static final int ENV_BOEi18n = 4;
    /**
     * 海外环境
     */
    public static final int ENV_i18n = 5;
    /**
     * 海外环境 ppe
     */
    public static final int ENV_PPEi18n = 6;
    /**
     * 默认环境
     */
    public static final int ENV_DEFAULT = ENV_RELEASE;


    /**
     *
     */
    public static final BIMAccountProvider accountProvider = new VEDefaultAccountProvider();

}

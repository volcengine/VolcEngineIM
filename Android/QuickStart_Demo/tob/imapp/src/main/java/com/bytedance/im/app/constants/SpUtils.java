package com.bytedance.im.app.constants;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;

import com.bytedance.im.app.in.login.model.UserStrToken;
import com.bytedance.im.app.in.login.model.UserToken;
import com.google.gson.Gson;

public class SpUtils {
    public static final String SP_NO_RESET_NAME = "no_reset_sp_key";
    public static final String SP_BOE_SWIM_LANE_KEY = "boe_swim_lane";
    public static final String SP_PPE_SWIM_LANE_KEY = "ppe_swim_lane";
    public static final String SP_I18N_PPE_SWIM_LANE_KEY = "i18n_ppe_swim_lane";
    public static final String SP_ENV_KEY = "env_key";
    public static final String SP_LOG_IN_INFO = "login_info";

    public static final String SP_LOG_IN_INFO_UID_STR = "login_info_uid_str";

    public static final String SP_ENABLE_ALOG = "enable_alog";    //埋点开关
    public static final String SP_ENABLE_APM = "enable_apm";    //日志开关
    public static final String SP_ENABLE_DEBUG_LOGIN = "enable_debug_login";//是否开启debug登录页面
    public static final String SP_LAST_LOGIN_UID_TYPE = "last_login_uid_type";//登录uid类型 0:数字 1:字符


    private boolean isInit = false;

    private static final class InstanceHolder {
        private static final SpUtils instance = new SpUtils();
    }


    private Context mContext;
    private SharedPreferences sp;

    private SpUtils() {

    }

    public static SpUtils getInstance() {
        return InstanceHolder.instance;
    }

    public void init(Context context) {
        if (!isInit) {
            mContext = context;
            sp = mContext.getSharedPreferences(SP_NO_RESET_NAME, Context.MODE_PRIVATE);
            isInit = true;
        }
    }


    public void setEnv(int env) {
        sp.edit().putInt(SP_ENV_KEY, env).commit();
    }

    public void setBoeSwimLane(String swimLane) {
        sp.edit().putString(SP_BOE_SWIM_LANE_KEY, swimLane).commit();
    }

    public void setPPeSwimLane(String swimLane) {
        sp.edit().putString(SP_PPE_SWIM_LANE_KEY, swimLane).commit();
    }

    public void setI18NPPeSwimLane(String swimLane) {
        sp.edit().putString(SP_I18N_PPE_SWIM_LANE_KEY, swimLane).commit();
    }

    public int getEnv() {
        return sp.getInt(SP_ENV_KEY, Constants.ENV_RELEASE);
    }

    public String getBoeSwimLane() {
        return sp.getString(SP_BOE_SWIM_LANE_KEY, "");
    }

    public String getPpeSwimLane() {
        return sp.getString(SP_PPE_SWIM_LANE_KEY, "");
    }

    public String getI18NPpeSwimLane() {
        return sp.getString(SP_I18N_PPE_SWIM_LANE_KEY, "");
    }

    public void setLoginUserInfo(UserToken userToken) {
        String loginUser = "";
        if (userToken != null) {
            loginUser = new Gson().toJson(userToken);
        }
        sp.edit().putString(SP_LOG_IN_INFO, loginUser).commit();
    }

    public UserToken getLoginUserInfo() {
        UserToken userToken = null;
        String infoStr = sp.getString(SP_LOG_IN_INFO, "");
        if (TextUtils.isEmpty(infoStr)) {
            return null;
        }
        try {
            userToken = new Gson().fromJson(infoStr, UserToken.class);
        } catch (Exception e) {
            return null;
        }
        return userToken;
    }

    public void setLoginUserStrInfo(UserStrToken userStrToken) {
        String loginUser = "";
        if (userStrToken != null) {
            loginUser = new Gson().toJson(userStrToken);
        }
        sp.edit().putString(SP_LOG_IN_INFO_UID_STR, loginUser).commit();
    }

    public UserStrToken getLoginUserStrInfo() {
        UserStrToken userToken = null;
        String infoStr = sp.getString(SP_LOG_IN_INFO_UID_STR, "");
        if (TextUtils.isEmpty(infoStr)) {
            return null;
        }
        try {
            userToken = new Gson().fromJson(infoStr, UserStrToken.class);
        } catch (Exception e) {
            return null;
        }
        return userToken;
    }


    public boolean isEnableALog() {
        return sp.getBoolean(SP_ENABLE_ALOG, true);
    }

    public void setEnableALog(boolean isEnable) {
        sp.edit().putBoolean(SP_ENABLE_ALOG, isEnable).commit();
    }

    public boolean isEnableAPM() {
        return sp.getBoolean(SP_ENABLE_APM, true);
    }

    public void setEnableAPM(boolean isEnable) {
        sp.edit().putBoolean(SP_ENABLE_APM, isEnable).commit();
    }

    public boolean isEnableDebugLogin() {
        return sp.getBoolean(SP_ENABLE_DEBUG_LOGIN, false);
    }

    public void setEnableDebugLogin(boolean isEnable) {
        sp.edit().putBoolean(SP_ENABLE_DEBUG_LOGIN, isEnable).commit();
    }

    /**
     * 上次登录是否是String uid
     *
     * @param
     */
    public int getLastLoginUidType() {
        return sp.getInt(SP_LAST_LOGIN_UID_TYPE, 0);
    }

    /**
     * 上次登录是否是String uid
     *
     * @param type 0数字 1字符
     */
    public void setLoginUidType(int type) {
        sp.edit().putInt(SP_LAST_LOGIN_UID_TYPE, type).commit();
    }
}

package com.bytedance.im.interfaces;


import android.app.Application;
import android.app.Fragment;

import com.bytedance.im.ui.api.interfaces.BIMCancelListener;
import com.bytedance.im.ui.user.BIMUserProvider;

/**
 * 账号提供者
 */
public interface BIMAccountProvider {
    /**
     * 初始化
     * @param application
     */
    void init(Application application, int appId, int env);

    /**
     * 用户是否存在
     *
     * @return
     */
    BIMUserExistChecker createUserExistChecker();

    /**
     * 登录页面
     *
     * @param <T>
     */
    <T extends Fragment & BIMAuthProvider> T createLoginFragment();

    /**
     *  注销账号
     * @param listener 注销回调
     * @param timeout  超时时间
     */
    void unregister(BIMCancelListener listener, long timeout);
}

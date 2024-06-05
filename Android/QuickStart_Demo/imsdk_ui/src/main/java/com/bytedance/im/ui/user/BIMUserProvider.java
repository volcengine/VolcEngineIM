package com.bytedance.im.ui.user;

import android.app.Application;

import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.List;

/**
 * @type callback
 * @brief 用户信息提供 provider,业务需要实现此接口,传递用户信息给 UI 组件。
 */
public interface BIMUserProvider {
    /**
     * @param uid 用户 id。
     * @return 用户信息, 参看 BIMUser{@link #BIMUser}
     * @type callback
     * @brief 获取用户信息，内存获取
     */
    BIMUIUser getUserInfo(long uid);

    /**
     * 从数据库获取用户资料，并加载到内存
     * @param uid
     * @param callback
     */
    void getUserInfoAsync(long uid, BIMResultCallback<BIMUIUser> callback);

    /**
     * 从数据库获取用户资料列表，并载到内存
     *
     * @param uid
     * @param callback
     */
    void getUserInfoListAsync(List<Long> uidList, BIMResultCallback<List<BIMUIUser>> callback);

    /**
     * 重新加载最新用户信息啊
     * @param uid
     */
    void reloadUserInfo(long uid);

    /**
     * 添加资料变更监听
     * @param listener
     */
    void addUserUpdateListener(OnUserInfoUpdateListener listener);
    /**
     * 移除资料变更监听
     * @param listener
     */
    void removeUserUpdateListener(OnUserInfoUpdateListener listener);

    /**
     * @hidden
     */
    void init(Application application);
}

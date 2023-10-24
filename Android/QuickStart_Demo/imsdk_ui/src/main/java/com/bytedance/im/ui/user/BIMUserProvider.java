package com.bytedance.im.ui.user;

import com.bytedance.im.ui.api.BIMUIUser;

/**
 * @type callback
 * @brief 用户信息提供 provider,业务需要实现此接口,传递用户信息给 UI 组件。
 */
public interface BIMUserProvider {
    /**
     * @param uid 用户 id。
     * @return 用户信息, 参看 BIMUser{@link #BIMUser}
     * @type callback
     * @brief 获取用户信息。
     */
    BIMUIUser getUserInfo(long uid);
}

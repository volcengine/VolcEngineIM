package com.bytedance.im.ui.user;

import com.bytedance.im.ui.api.BIMUIUser;

public interface OnUserInfoUpdateListener {
    void onUpdate(long uid, BIMUIUser user);
}

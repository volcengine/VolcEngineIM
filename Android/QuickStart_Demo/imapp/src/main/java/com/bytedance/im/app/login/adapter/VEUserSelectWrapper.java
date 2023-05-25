package com.bytedance.im.app.login.adapter;

import com.bytedance.im.ui.user.BIMUser;

public class VEUserSelectWrapper {
    private BIMUser user;
    protected boolean isSelect;

    public VEUserSelectWrapper(com.bytedance.im.ui.user.BIMUser user) {
        this.user = user;
    }

    public com.bytedance.im.ui.user.BIMUser getUser() {
        return user;
    }
}

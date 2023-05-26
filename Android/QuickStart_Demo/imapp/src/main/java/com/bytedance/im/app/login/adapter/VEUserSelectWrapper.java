package com.bytedance.im.app.login.adapter;

import com.bytedance.im.ui.api.BIMUser;

public class VEUserSelectWrapper {
    private BIMUser user;
    protected boolean isSelect;

    public VEUserSelectWrapper(BIMUser user) {
        this.user = user;
    }

    public BIMUser getUser() {
        return user;
    }
}

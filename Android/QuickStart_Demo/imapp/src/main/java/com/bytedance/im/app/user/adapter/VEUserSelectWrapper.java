package com.bytedance.im.app.user.adapter;

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

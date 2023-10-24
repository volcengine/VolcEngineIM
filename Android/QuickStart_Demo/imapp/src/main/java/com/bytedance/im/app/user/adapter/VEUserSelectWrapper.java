package com.bytedance.im.app.user.adapter;

import com.bytedance.im.ui.api.BIMUIUser;

public class VEUserSelectWrapper {
    private BIMUIUser user;
    protected boolean isSelect;

    public VEUserSelectWrapper(BIMUIUser user) {
        this.user = user;
    }

    public BIMUIUser getUser() {
        return user;
    }
}

package com.bytedance.im.app.member.user;

import com.bytedance.im.ui.api.BIMUIUser;

public class VEUserSelectWrapper {
    private BIMUIUser user;
    public boolean isSelect;

    public VEUserSelectWrapper(BIMUIUser user) {
        this.user = user;
    }

    public BIMUIUser getUser() {
        return user;
    }
}

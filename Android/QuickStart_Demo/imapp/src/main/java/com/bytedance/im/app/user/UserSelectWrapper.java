package com.bytedance.im.app.user;


import com.bytedance.im.ui.api.BIMUIUser;

public class UserSelectWrapper extends BaseSelectWrapper<BIMUIUser>{
    private boolean isShowUid;
    public UserSelectWrapper(BIMUIUser user, int layoutId, boolean isShowUid) {
        this.t = user;
        this.layoutId = layoutId;
        this.isShowUid = isShowUid;
    }

    public boolean isShowUid() {
        return isShowUid;
    }
}

package com.bytedance.im.app.user;


import com.bytedance.im.ui.api.BIMUser;

public class UserSelectWrapper extends BaseSelectWrapper<BIMUser>{
    private boolean isShowUid;
    public UserSelectWrapper(BIMUser user, int layoutId, boolean isShowUid) {
        this.t = user;
        this.layoutId = layoutId;
        this.isShowUid = isShowUid;
    }

    public boolean isShowUid() {
        return isShowUid;
    }
}

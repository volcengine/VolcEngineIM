package com.bytedance.im.app.member.user;


import com.bytedance.im.ui.api.BIMUIUser;

public class UserSelectWrapper extends BaseSelectWrapper<BIMUIUser>{
    private boolean isShowUid;
    public UserSelectWrapper(BIMUIUser userFullInfo, int layoutId, boolean isShowUid) {
        this.t = userFullInfo;
        this.layoutId = layoutId;
        this.isShowUid = isShowUid;
    }

    public boolean isShowUid() {
        return isShowUid;
    }
}

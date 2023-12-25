package com.bytedance.im.app.user;


import com.bytedance.im.user.api.model.BIMUserFullInfo;

public class UserSelectWrapper extends BaseSelectWrapper<BIMUserFullInfo>{
    private boolean isShowUid;
    public UserSelectWrapper(BIMUserFullInfo userFullInfo, int layoutId, boolean isShowUid) {
        this.t = userFullInfo;
        this.layoutId = layoutId;
        this.isShowUid = isShowUid;
    }

    public boolean isShowUid() {
        return isShowUid;
    }
}

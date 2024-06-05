package com.bytedance.im.app.live.member.adapter;


import com.bytedance.im.ui.api.BIMUIUser;

public class VELiveUserSelectWrapper extends VELiveBaseSelectWrapper<BIMUIUser>{
    private boolean isShowUid;
    public VELiveUserSelectWrapper(BIMUIUser user, int layoutId, boolean isShowUid) {
        this.t = user;
        this.layoutId = layoutId;
        this.isShowUid = isShowUid;
    }

    public boolean isShowUid() {
        return isShowUid;
    }
}

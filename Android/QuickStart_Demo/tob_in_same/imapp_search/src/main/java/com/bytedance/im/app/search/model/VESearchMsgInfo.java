package com.bytedance.im.app.search.model;

import com.bytedance.im.search.api.model.BIMSearchMsgInfo;
import com.bytedance.im.ui.api.BIMUIUser;

public class VESearchMsgInfo {
    private BIMSearchMsgInfo searchMsgInfo;
    private BIMUIUser user;

    public VESearchMsgInfo(BIMSearchMsgInfo searchMsgInfo, BIMUIUser userInfo) {
        this.searchMsgInfo = searchMsgInfo;
        this.user = userInfo;
    }

    public BIMSearchMsgInfo getSearchMsgInfo() {
        return searchMsgInfo;
    }

    public BIMUIUser getUser() {
        return user;
    }
}

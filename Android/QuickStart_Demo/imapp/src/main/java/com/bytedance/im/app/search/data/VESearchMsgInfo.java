package com.bytedance.im.app.search.data;

import com.bytedance.im.search.api.model.BIMSearchMsgInfo;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

public class VESearchMsgInfo {
    private BIMSearchMsgInfo searchMsgInfo;
    private BIMUserFullInfo userFullInfo;

    public VESearchMsgInfo(BIMSearchMsgInfo searchMsgInfo, BIMUserFullInfo userFullInfo) {
        this.searchMsgInfo = searchMsgInfo;
        this.userFullInfo = userFullInfo;
    }

    public BIMSearchMsgInfo getSearchMsgInfo() {
        return searchMsgInfo;
    }

    public BIMUserFullInfo getUserFullInfo() {
        return userFullInfo;
    }
}

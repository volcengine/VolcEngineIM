package com.bytedance.im.app.search.global.contact.model;

import com.bytedance.im.search.api.model.BIMSearchFriendInfo;
import com.bytedance.im.search.api.model.BIMUserBaseInfo;

public class SearchFriendGWrapper {
    private BIMSearchFriendInfo bimSearchFriendInfo;
    private BIMUserBaseInfo userInfo;

    public SearchFriendGWrapper(BIMSearchFriendInfo bimSearchFriendInfo, BIMUserBaseInfo userInfo) {
        this.bimSearchFriendInfo = bimSearchFriendInfo;
        this.userInfo = userInfo;
    }

    public BIMSearchFriendInfo getBimSearchFriendInfo() {
        return bimSearchFriendInfo;
    }

    public BIMUserBaseInfo getUserInfo() {
        return userInfo;
    }
}

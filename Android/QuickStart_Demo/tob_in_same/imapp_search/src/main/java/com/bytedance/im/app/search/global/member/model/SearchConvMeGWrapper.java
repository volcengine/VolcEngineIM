package com.bytedance.im.app.search.global.member.model;

import com.bytedance.im.search.api.model.BIMSearchMemberInfo;
import com.bytedance.im.ui.api.BIMUIUser;

public class SearchConvMeGWrapper {
    private BIMSearchMemberInfo searchMemberInfo;
    private BIMUIUser user;
    private boolean isShowTag = true;
    private boolean isShowOnline = false;
    private boolean isShowSilent = false;

    public SearchConvMeGWrapper(BIMSearchMemberInfo searchMemberInfo, BIMUIUser user) {
        this.searchMemberInfo = searchMemberInfo;
        this.user = user;
    }

    public BIMSearchMemberInfo getSearchMemberInfo() {
        return searchMemberInfo;
    }

    public BIMUIUser getUser() {
        return user;
    }

    public boolean isShowTag() {
        return isShowTag;
    }

    public boolean isShowOnline() {
        return isShowOnline;
    }

    public boolean isShowSilent() {
        return isShowSilent;
    }
}

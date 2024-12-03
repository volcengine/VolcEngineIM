package com.bytedance.im.app.search.global.group.model;

import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.search.api.model.BIMSearchGroupInfo;

public class SearchGroupGWrapper {
    private BIMConversation conversation;
    private BIMSearchGroupInfo searchGroupInfo;

    public SearchGroupGWrapper(BIMConversation conversation, BIMSearchGroupInfo searchGroupInfo) {
        this.conversation = conversation;
        this.searchGroupInfo = searchGroupInfo;
    }

    public BIMConversation getConversation() {
        return conversation;
    }

    public BIMSearchGroupInfo getSearchGroupInfo() {
        return searchGroupInfo;
    }
}

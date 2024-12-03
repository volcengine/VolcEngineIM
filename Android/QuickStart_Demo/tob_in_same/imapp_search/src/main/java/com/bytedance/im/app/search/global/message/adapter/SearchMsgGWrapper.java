package com.bytedance.im.app.search.global.message.adapter;

import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.search.api.model.BIMSearchMsgInConvInfo;

public class SearchMsgGWrapper {
    private BIMSearchMsgInConvInfo searchInfo;
    private BIMConversation conversation;

    public SearchMsgGWrapper(BIMSearchMsgInConvInfo searchInfo, BIMConversation conversation) {
        this.searchInfo = searchInfo;
        this.conversation = conversation;
    }

    public BIMSearchMsgInConvInfo getSearchInfo() {
        return searchInfo;
    }

    public BIMConversation getConversation() {
        return conversation;
    }
}

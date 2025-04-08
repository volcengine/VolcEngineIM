package com.bytedance.im.ui.conversation.model;

import com.bytedance.im.core.api.model.BIMConversation;

public class VEConvBaseStickTopWrapper extends VEConvBaseWrapper<BIMConversation> {
    private long sortOrder = 0;

    public VEConvBaseStickTopWrapper(BIMConversation conversation, int type) {
        super(conversation, type);
    }

    @Override
    public long getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(long sortOrder) {
        this.sortOrder = sortOrder;
    }

    @Override
    public long getConversationShortId() {
        return t.getConversationShortID();
    }

    @Override
    public String getConversationId() {
        return t.getConversationID();
    }
}

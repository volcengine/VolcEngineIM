package com.bytedance.im.ui.conversation.model;

import com.bytedance.im.core.api.model.BIMConversation;

public class VEConversationWrapper extends VEConvBaseWrapper<BIMConversation> {
    public VEConversationWrapper(BIMConversation conversation, int type) {
        super(conversation, type);
    }

    @Override
    public long getSortOrder() {
        return t.getSortOrder();
    }

    @Override
    public String getConversationId() {
        return t.getConversationID();
    }
}

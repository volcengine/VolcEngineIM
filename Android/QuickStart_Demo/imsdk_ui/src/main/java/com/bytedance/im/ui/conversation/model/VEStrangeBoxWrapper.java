package com.bytedance.im.ui.conversation.model;

import com.bytedance.im.core.api.model.BIMStrangeBox;

public class VEStrangeBoxWrapper extends VEConvBaseWrapper<BIMStrangeBox>{

    public VEStrangeBoxWrapper(BIMStrangeBox strangeBox, int type) {
        super(strangeBox, type);
    }

    @Override
    public long getSortOrder() {
//        return getInfo().getBimConversation().getSortOrder();
        return ORDER_TOP_STRANGE;//陌生人盒子位于顶部
    }

    @Override
    public String getConversationId() {
//        return getInfo().getBimConversation().getConversationID();
        return "strangeBox";
    }
}

package com.bytedance.im.app.search.model;

import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.api.BIMUIUser;

public class VEMediaWrapper {
    private BIMMessage bimMessage;
    private BIMUIUser bimuiUser;

    public VEMediaWrapper(BIMMessage bimMessage, BIMUIUser bimuiUser) {
        this.bimMessage = bimMessage;
        this.bimuiUser = bimuiUser;
    }

    public BIMMessage getBimMessage() {
        return bimMessage;
    }

    public BIMUIUser getBimuiUser() {
        return bimuiUser;
    }
}

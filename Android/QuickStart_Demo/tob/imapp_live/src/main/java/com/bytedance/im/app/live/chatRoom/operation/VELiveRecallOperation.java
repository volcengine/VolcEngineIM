package com.bytedance.im.app.live.chatRoom.operation;

import android.view.View;

import com.bytedance.im.app.live.R;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;

public class VELiveRecallOperation extends BIMMessageOperation {
    public VELiveRecallOperation() {
        super(R.drawable.icon_msg_option_menu_recall, "撤回");
    }

    public VELiveRecallOperation(int resId, String name) {
        super(resId, name);
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {
        //todo live recall

    }
}

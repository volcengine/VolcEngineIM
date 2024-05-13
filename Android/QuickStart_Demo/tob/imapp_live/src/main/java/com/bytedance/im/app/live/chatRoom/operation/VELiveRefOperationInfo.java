package com.bytedance.im.app.live.chatRoom.operation;

import android.view.View;


import com.bytedance.im.app.live.R;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;

public class VELiveRefOperationInfo extends BIMMessageOperation {
    public VELiveRefOperationInfo() {
        super(R.drawable.icon_msg_option_menu_read_callback, "引用");
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {
        //实现在 BIMLiveMessageOptionPopWindow 
    }
}

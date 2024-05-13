package com.bytedance.im.app.live.chatRoom.operation;

import android.view.View;


import com.bytedance.im.app.live.R;
import com.bytedance.im.core.api.enums.BIMMessageStatus;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.live.api.enmus.BIMMessagePriority;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;

public class VELivePriorityInfo extends BIMMessageOperation {

    public VELivePriorityInfo(int resId, String name) {
        super(resId, name);
    }

    public static VELivePriorityInfo create(BIMMessage bimMessage) {
        String name = "未知";
        if (bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS||
        bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL) {
            BIMMessagePriority priority = bimMessage.getPriority();
            switch (priority) {
                case LOW:
                    name = "低";
                    break;
                case NORMAL:
                    name = "普通";
                    break;
                case HIGH:
                    name = "高";
                    break;
                default:
                    break;
            }
        }
        return new VELivePriorityInfo(R.drawable.icon_msg_option_menu_read_callback, name);
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {

    }
}

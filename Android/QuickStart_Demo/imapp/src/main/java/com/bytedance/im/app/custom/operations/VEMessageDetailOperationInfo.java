package com.bytedance.im.app.custom.operations;

import android.view.View;

import com.bytedance.im.app.message.detail.VEMessageDetailActivity;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;

/**
 * 查看消息详情
 */
public class VEMessageDetailOperationInfo extends BIMMessageOperation {
    public VEMessageDetailOperationInfo() {
        super(com.bytedance.im.ui.R.drawable.icon_msg_option_menu_read_callback, "详情");
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {
        if (!veMessageListFragment.isAdded()) {
            return;
        }
        VEMessageDetailActivity.start(veMessageListFragment.getActivity(), bimMessage.getServerMsgId(),bimMessage.getConversationShortID());
    }
}

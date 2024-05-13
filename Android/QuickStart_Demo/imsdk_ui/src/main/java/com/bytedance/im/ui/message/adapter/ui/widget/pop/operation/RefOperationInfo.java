package com.bytedance.im.ui.message.adapter.ui.widget.pop.operation;

import android.view.View;

import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;

public class RefOperationInfo extends BIMMessageOperation {

    public RefOperationInfo() {
        super(R.drawable.icon_msg_option_menu_read_callback, "引用");
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {
    }
}

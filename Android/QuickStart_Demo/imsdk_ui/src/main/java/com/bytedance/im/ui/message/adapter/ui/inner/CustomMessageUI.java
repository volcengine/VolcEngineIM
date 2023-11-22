package com.bytedance.im.ui.message.adapter.ui.inner;

import android.view.View;

import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;

public class CustomMessageUI extends BaseCustomElementUI {
    @Override
    public int getLayoutId() {
        return 0;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {

    }

    @Override
    public boolean onLongClickListener(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        return false;
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {

    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return bimMessage.getServerMsgId() > 0;
    }
}

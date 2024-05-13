package com.bytedance.im.ui.message.adapter.ui.inner;

import android.view.View;

import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMCustomElement;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
@CustomUIType(contentCls = BIMCustomElement.class)
public class CustomMessageDefaultUI extends BaseCustomElementUI {
    @Override
    public int getLayoutId() {
        return R.layout.bim_message_item_custom_base_layout;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {

    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {

    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return false;
    }
}

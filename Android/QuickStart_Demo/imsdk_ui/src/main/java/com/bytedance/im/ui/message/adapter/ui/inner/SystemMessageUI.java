package com.bytedance.im.ui.message.adapter.ui.inner;

import android.view.View;
import android.widget.TextView;

import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMSystemElement;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;

@CustomUIType(contentCls = BIMSystemElement.class)
public class SystemMessageUI extends BaseCustomElementUI {
    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_system;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView textView = v.findViewById(R.id.tv_msg_system_content);
        BIMSystemElement systemElement = (BIMSystemElement) messageWrapper.getBimMessage().getElement();
        textView.setText(systemElement.getText());

    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {

    }

    @Override
    public boolean isEnableReceipt(BIMMessage bimMessage) {
        return false;
    }

    @Override
    public boolean needHorizonCenterParent() {
        return true;
    }

    @Override
    public boolean needPortraitGone() {
        return true;
    }

    @Override
    public boolean isForceStatusGone() {
        return true;
    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return false;
    }

    @Override
    public boolean isEnableDelete(BIMMessage bimMessage) {
        return false;
    }

    @Override
    public boolean isEnableRecall(BIMMessage bimMessage) {
        return false;
    }

    @Override
    public boolean isEnableEdit(BIMMessage bimMessage) {
        return false;
    }

    @Override
    public boolean isEnableCopy(BIMMessage bimMessage) {
        return false;
    }
}

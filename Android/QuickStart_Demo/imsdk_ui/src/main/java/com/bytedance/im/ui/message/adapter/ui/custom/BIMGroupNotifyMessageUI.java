package com.bytedance.im.ui.message.adapter.ui.custom;

import android.view.View;
import android.widget.TextView;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.core.api.model.BIMMessage;


@CustomUIType(contentCls = BIMGroupNotifyElement.class)
public class BIMGroupNotifyMessageUI extends BaseCustomElementUI {

    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_system;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder,View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView mContent = v.findViewById(R.id.tv_msg_system_content);
        BIMMessage bimMessage = messageWrapper.getBimMessage();
        BIMGroupNotifyElement content = (BIMGroupNotifyElement) bimMessage.getElement();
        mContent.setText(content.getText());
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {

    }

    @Override
    public boolean needPortraitGone() {
        return true;
    }

    @Override
    public boolean needHorizonCenterParent() {
        return true;
    }


    @Override
    public boolean isEnableCopy(BIMMessage bimMessage) {
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
    public boolean isEnableReceipt(BIMMessage bimMessage) {
        return false;
    }
}


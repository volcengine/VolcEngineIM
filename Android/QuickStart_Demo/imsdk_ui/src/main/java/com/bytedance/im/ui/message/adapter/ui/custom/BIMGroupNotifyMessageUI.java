package com.bytedance.im.ui.message.adapter.ui.custom;

import android.view.View;
import android.widget.TextView;

import com.bytedance.im.ui.R;
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
    public void onBindView(View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView mContent = v.findViewById(R.id.tv_msg_system_content);
        BIMMessage bimMessage = messageWrapper.getBimMessage();
        BIMGroupNotifyElement content = (BIMGroupNotifyElement) bimMessage.getElement();
        mContent.setText(content.getText());
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
    public boolean onLongClickListener(View v, BIMMessageWrapper messageWrapper) {
        return false;
    }

    @Override
    public void onClick(View v, BIMMessageWrapper messageWrapper) {

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
}


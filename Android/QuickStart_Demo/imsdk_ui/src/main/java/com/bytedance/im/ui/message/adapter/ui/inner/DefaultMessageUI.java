package com.bytedance.im.ui.message.adapter.ui.inner;

import android.view.View;
import android.widget.TextView;


import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMBaseElement;

@CustomUIType(contentCls = BIMBaseElement.class)
public class DefaultMessageUI extends BaseCustomElementUI {
    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_default_message;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView tvDefault = v.findViewById(R.id.tv_default);
        BIMMessage bimMessage = messageWrapper.getBimMessage();
        tvDefault.setText("暂不支持此消息: " + bimMessage.getMsgType() +"\n content: "+bimMessage.getContentData());
    }

    @Override
    public boolean onLongClickListener(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        return false;
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {

    }
}

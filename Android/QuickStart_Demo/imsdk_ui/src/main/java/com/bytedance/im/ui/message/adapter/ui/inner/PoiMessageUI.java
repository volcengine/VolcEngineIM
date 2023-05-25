package com.bytedance.im.ui.message.adapter.ui.inner;

import android.view.View;
import android.widget.TextView;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMPoiElement;

@CustomUIType(contentCls = BIMPoiElement.class)
public class PoiMessageUI extends BaseCustomElementUI {

    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_poi;
    }

    @Override
    public void onBindView(View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView showPoi = v.findViewById(R.id.show_poi);
        showPoi.setText(messageWrapper.getBimMessage().getContentData());
    }

    @Override
    public boolean onLongClickListener(View v, BIMMessageWrapper messageWrapper) {
        return false;
    }

    @Override
    public void onClick(View v, BIMMessageWrapper messageWrapper) {

    }

    @Override
    public boolean isEnableRecall(BIMMessage bimMessage) {
        return bimMessage.isSelf();
    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return bimMessage.getServerMsgId() > 0;
    }
}

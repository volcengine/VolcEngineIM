package com.bytedance.im.ui.message.adapter.ui.custom;

import android.content.Intent;
import android.net.Uri;
import android.view.View;
import android.widget.TextView;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.core.api.model.BIMMessage;

@CustomUIType(contentCls = BIMShareElement.class)
public class BIMShareCustomMessageUI extends BaseCustomElementUI {
    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_share_ve;
    }

    @Override
    public void onBindView(View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView tvTitle = v.findViewById(R.id.tv_title);
        TextView tvLink = v.findViewById(R.id.tv_link);
        BIMMessage bimMessage = messageWrapper.getBimMessage();
        View root = v.findViewById(R.id.custom_root);
        if (bimMessage.isSelf()) {
            root.setBackgroundResource(R.drawable.shape_im_conversation_msg_send_bg);
            tvTitle.setTextColor(tvTitle.getContext().getResources().getColor(R.color.business_base_white));
        } else {
            root.setBackgroundResource(R.drawable.shape_im_conversation_msg_receive_bg);
            tvTitle.setTextColor(tvTitle.getContext().getResources().getColor(R.color.business_im_222));
        }
        BIMShareElement content = (BIMShareElement) bimMessage.getElement();
    }

    @Override
    public boolean onLongClickListener(View v, BIMMessageWrapper messageWrapper) {
        return false;
    }

    @Override
    public void onClick(View v, BIMMessageWrapper messageWrapper) {
        BIMShareElement content = (BIMShareElement) messageWrapper.getBimMessage().getElement();
        Intent intent = new Intent();
        intent.setAction("android.intent.action.VIEW");
        Uri content_url = Uri.parse(content.getLink());
        intent.setData(content_url);
        v.getContext().startActivity(intent);
    }

    @Override
    public boolean isEnableRecall(BIMMessage bimMessage) {
        return true;
    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return true;
    }
}

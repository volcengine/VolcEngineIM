package com.bytedance.im.app.live.conversation;

import android.support.annotation.NonNull;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.conversation.adapter.VEViewHolder;
import com.bytedance.im.ui.conversation.model.VEConvBaseWrapper;

public class VELiveGroupViewHolder extends VEViewHolder<VEConvBaseWrapper<BIMConversation>> {
    private ImageView userHeadImg;
    private TextView nickName;
    private TextView tvDetail;

    public VELiveGroupViewHolder(@NonNull View itemView) {
        super(itemView);
        userHeadImg = itemView.findViewById(R.id.iv_conversation_user_img);
        nickName = itemView.findViewById(R.id.tv_conversation_user_name);
        tvDetail = itemView.findViewById(R.id.tv_detail);
    }

    @Override
    public void bind(VEConvBaseWrapper<BIMConversation> conversationVEConversationWrapper) {
        BIMConversation bimConversation = conversationVEConversationWrapper.getInfo();
        nickName.setText(bimConversation.getName());
        String url = bimConversation.getPortraitURL();
        if (TextUtils.isEmpty(url)) {
            userHeadImg.setImageResource(R.drawable.default_icon_group);
        } else {
            loadUrl(userHeadImg, url);
        }
        int textColor = R.color.business_im_222;
        if (bimConversation.isDissolved()) {
            textColor = R.color.business_im_999;
        }
        nickName.setTextColor(itemView.getContext().getResources().getColor(textColor));
        BIMConversation conversation = conversationVEConversationWrapper.getInfo();
        if (conversation.getOwnerId() == BIMClient.getInstance().getCurrentUserID()) {
            tvDetail.setText("群主");
            tvDetail.setVisibility(View.VISIBLE);
        } else {
            tvDetail.setVisibility(View.GONE);
        }
    }

    private void loadUrl(ImageView userHeadImg, String url) {
        Glide.with(userHeadImg.getContext()).load(url).placeholder(R.drawable.default_icon_group).error(R.drawable.default_icon_group).into(userHeadImg);
    }
}

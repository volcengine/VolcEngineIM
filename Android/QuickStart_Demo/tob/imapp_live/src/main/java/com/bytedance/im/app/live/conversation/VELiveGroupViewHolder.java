package com.bytedance.im.app.live.conversation;

import androidx.annotation.NonNull;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.live.R;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
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
        BIMMember curMember = conversation.getCurrentMember();
        tvDetail.setVisibility(View.GONE);
        if (curMember != null) {
            tvDetail.setVisibility(View.VISIBLE);
            if (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                tvDetail.setText("群主");
            } else if (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
                tvDetail.setText("管理员");
            } else if (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_NORMAL) {
                tvDetail.setText(" ");
            } else if (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_VISITOR) {
                tvDetail.setText(" ");
            }
        }
    }

    private void loadUrl(ImageView userHeadImg, String url) {
        Glide.with(userHeadImg.getContext()).load(url).placeholder(R.drawable.default_icon_group).error(R.drawable.default_icon_group).into(userHeadImg);
    }
}

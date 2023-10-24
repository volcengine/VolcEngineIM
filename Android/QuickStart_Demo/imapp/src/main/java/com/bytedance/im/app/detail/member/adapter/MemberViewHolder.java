package com.bytedance.im.app.detail.member.adapter;

import android.graphics.Color;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.R;
import com.bytedance.im.app.contact.VEFriendInfoManager;
import com.bytedance.im.core.api.enums.BIMBlockStatus;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;

public class MemberViewHolder extends RecyclerView.ViewHolder {

    private ImageView userHeadImg;
    private TextView nickName;
    protected ImageView ivSilent;

    public MemberViewHolder(@NonNull View itemView) {
        super(itemView);
        userHeadImg = itemView.findViewById(R.id.iv_head);
        nickName = itemView.findViewById(R.id.tv_nick_name);
        ivSilent = itemView.findViewById(R.id.iv_silent);
    }

    public void bind(MemberWrapper memberWrapper) {
        BIMMember member = memberWrapper.getMember();
        //名称
        String name = "用户" + member.getUserID();
        String friendAlias = VEFriendInfoManager.getInstance().getFriendAlias(member.getUserID());
        if (!TextUtils.isEmpty(friendAlias)) {
            name = friendAlias;
        } else {
            if (member != null && !TextUtils.isEmpty(member.getAlias())) {
                name = member.getAlias();
            }
        }
        if (memberWrapper.isShowTag()) {
            if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                name += "[群主]";
            } else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
                name += "[管理员]";
            }
        }
        boolean showOnlineTag = memberWrapper.isShowOnline() &&(member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN || member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER);
        if (showOnlineTag) {
            if (member.isOnline()) {
                name += " 在线";
            } else {
                name += " 离线";
            }
        }

        SpannableString nameSpannableStr = new SpannableString(name);
        if (showOnlineTag && nameSpannableStr.length() >= 2) {
            nameSpannableStr.setSpan(new ForegroundColorSpan(Color.LTGRAY), nameSpannableStr.length() - 2, nameSpannableStr.length(), 0);
        }
        nickName.setText(nameSpannableStr);

        //头像
        int res = R.drawable.icon_recommend_user_default;
        userHeadImg.setImageResource(res);
        String avatarUlr = member.getAvatarUrl();
        if (!TextUtils.isEmpty(avatarUlr)) {
            Glide.with(userHeadImg.getContext()).load(avatarUlr).error(res).into(userHeadImg);
        }

        //禁言标签
        if (memberWrapper.isShowSilent()) {
            if (member.getSilentStatus() == BIMBlockStatus.BIM_BLOCK_STATUS_BLOCK) {
                ivSilent.setVisibility(View.VISIBLE);
            } else {
                ivSilent.setVisibility(View.GONE);
            }
        } else {
            ivSilent.setVisibility(View.GONE);
        }
    }
}

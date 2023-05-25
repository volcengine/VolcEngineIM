package com.bytedance.im.app.detail.member.adapter;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.enums.BIMBlockStatus;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.user.BIMUser;
import com.bytedance.im.ui.user.UserManager;

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
        BIMUser user = UserManager.geInstance().getUserProvider().getUserInfo(member.getUserID());
        String name = "" + member.getUserID();
        int res = R.drawable.icon_recommend_user_default;
        if (user != null) {
            res = user.getHeadImg();
            name = user.getNickName();
        }
        userHeadImg.setImageResource(res);
        if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
            name += "[群主]";
        } else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
            name += "[管理员]";
        }
        if (memberWrapper.isForceSilentGone()) {
            ivSilent.setVisibility(View.GONE);
        } else {
            if (member.getSilentStatus() == BIMBlockStatus.BIM_BLOCK_STATUS_BLOCK) {
                ivSilent.setVisibility(View.VISIBLE);
            } else {
                ivSilent.setVisibility(View.GONE);
            }
        }
        nickName.setText(name);
    }
}

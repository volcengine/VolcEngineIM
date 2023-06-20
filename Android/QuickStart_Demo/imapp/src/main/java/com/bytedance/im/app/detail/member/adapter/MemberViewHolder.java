package com.bytedance.im.app.detail.member.adapter;

import android.graphics.Color;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.enums.BIMBlockStatus;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.api.BIMUser;
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
//        else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_VISITOR) {
//            name += "[游客]";
//        } else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_NORMAL) {
//            name += "[成员]";
//        }
        boolean showOnlineTag = memberWrapper.isShowOnline() &&(member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN || member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER);
        if (showOnlineTag) {
            if (member.isOnline()) {
                name += " 在线";
            } else {
                name += " 离线";
            }
        }
        if (memberWrapper.isShowSilent()) {
            if (member.getSilentStatus() == BIMBlockStatus.BIM_BLOCK_STATUS_BLOCK) {
                ivSilent.setVisibility(View.VISIBLE);
            } else {
                ivSilent.setVisibility(View.GONE);
            }
        } else {
            ivSilent.setVisibility(View.GONE);
        }

        SpannableString nameSpannableStr = new SpannableString(name);
        if (showOnlineTag && nameSpannableStr.length() >= 2) {
            nameSpannableStr.setSpan(new ForegroundColorSpan(Color.LTGRAY), nameSpannableStr.length() - 2, nameSpannableStr.length(), 0);
        }
        nickName.setText(nameSpannableStr);
    }
}

package com.bytedance.im.ui.member;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.ui.user.UserManager;

public class BIMMemberViewHolder extends RecyclerView.ViewHolder {

    private ImageView userHeadImg;
    private TextView nickName;

    public BIMMemberViewHolder(@NonNull View itemView) {
        super(itemView);
        userHeadImg = itemView.findViewById(R.id.iv_head);
        nickName = itemView.findViewById(R.id.tv_nick_name);

    }

    public void bind(BIMMemberWrapper memberWrapper) {
        BIMMember member = memberWrapper.getMember();
        BIMUser user = UserManager.geInstance().getUserProvider().getUserInfo(member.getUserID());
        String name = "" + member.getUserID();
        int res = R.drawable.icon_recommend_user_default;
        userHeadImg.setImageResource(res);
        if (user != null) {
            res = user.getHeadImg();
            name = user.getNickName();
            if (TextUtils.isEmpty(user.getUrl())) {
                userHeadImg.setImageResource(res);
            } else {
                Glide.with(userHeadImg.getContext()).load(user.getUrl())
                        .placeholder(R.drawable.icon_recommend_user_default)
                        .error(R.drawable.icon_recommend_user_default)
                        .into(userHeadImg);
            }
        }
        nickName.setText(name);
    }
}

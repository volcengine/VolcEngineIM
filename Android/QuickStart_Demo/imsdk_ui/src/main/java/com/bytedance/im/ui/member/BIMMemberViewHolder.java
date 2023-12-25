package com.bytedance.im.ui.member;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.BIMUIUser;

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
        BIMUIUser user = memberWrapper.getUser();
        String name = "" + member.getUserID();
        int res = R.drawable.icon_recommend_user_default;
        userHeadImg.setImageResource(res);
        if (user != null) {
            if (!TextUtils.isEmpty(user.getNickName())) {
                name = user.getNickName();
            }
            if (!TextUtils.isEmpty(user.getAlias())) {
                name = user.getAlias();
            }
            Glide.with(userHeadImg.getContext()).load(user.getPortraitUrl())
                    .placeholder(R.drawable.icon_recommend_user_default)
                    .error(R.drawable.icon_recommend_user_default)
                    .into(userHeadImg);
        }
        nickName.setText(name);
    }
}

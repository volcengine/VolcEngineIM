package com.bytedance.im.app.member.user;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;


import com.bytedance.im.app.member.R;
import com.bumptech.glide.Glide;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;


public class UserViewHolder extends RecyclerView.ViewHolder {
    private ImageView userHeadImg;
    private TextView nickName;

    public UserViewHolder(@NonNull View itemView) {
        super(itemView);
        userHeadImg = itemView.findViewById(R.id.iv_head);
        nickName = itemView.findViewById(R.id.tv_nick_name);

    }

    public void bind(BIMUIUser user) {
        if (TextUtils.isEmpty(user.getPortraitUrl())){
            userHeadImg.setImageResource(R.drawable.icon_recommend_user_default);
        }else{
            Glide.with(userHeadImg.getContext()).load(user.getPortraitUrl())
                    .placeholder(com.bytedance.im.ui.R.drawable.icon_recommend_user_default)
                    .error(com.bytedance.im.ui.R.drawable.icon_recommend_user_default)
                    .into(userHeadImg);
        }
        nickName.setText(BIMUINameUtils.getShowName(user));
    }
}

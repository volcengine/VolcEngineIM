package com.bytedance.im.app.user;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.ui.api.BIMUser;


public class UserViewHolder extends RecyclerView.ViewHolder {
    private ImageView userHeadImg;
    private TextView nickName;

    public UserViewHolder(@NonNull View itemView) {
        super(itemView);
        userHeadImg = itemView.findViewById(R.id.iv_head);
        nickName = itemView.findViewById(R.id.tv_nick_name);

    }

    public void bind(BIMUser user) {
        userHeadImg.setImageResource(user.getHeadImg());
        nickName.setText(user.getNickName());
    }
}

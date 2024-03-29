package com.bytedance.im.app.user;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.ui.api.BIMUIUser;


public class UserViewHolder extends RecyclerView.ViewHolder {
    private ImageView userHeadImg;
    private TextView nickName;

    public UserViewHolder(@NonNull View itemView) {
        super(itemView);
        userHeadImg = itemView.findViewById(R.id.iv_head);
        nickName = itemView.findViewById(R.id.tv_nick_name);

    }

    public void bind(BIMUIUser user) {
        userHeadImg.setImageResource(R.drawable.icon_recommend_user_default);
        nickName.setText(user.getNickName());
    }
}

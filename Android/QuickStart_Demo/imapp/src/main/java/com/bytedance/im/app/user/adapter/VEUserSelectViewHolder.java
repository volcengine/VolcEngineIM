package com.bytedance.im.app.user.adapter;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;


public class VEUserSelectViewHolder extends RecyclerView.ViewHolder {
    public VEUserSelectViewHolder(@NonNull View itemView) {
        super(itemView);
        checkBox = itemView.findViewById(R.id.checkbox_user);
        ivHead = itemView.findViewById(R.id.iv_head);
        tvNickName = itemView.findViewById(R.id.tv_nick_name);
        tvUid = itemView.findViewById(R.id.tv_uuid);
    }

    private ImageView checkBox;
    private ImageView ivHead;
    private TextView tvNickName;
    private TextView tvUid;
    private VEUserSelectWrapper selectWrapper;

    protected void bind(VEUserSelectWrapper userSelectWrapper) {
        selectWrapper = userSelectWrapper;
        ivHead.setImageResource(R.drawable.icon_recommend_user_default);
        tvNickName.setText(userSelectWrapper.getUser().getNickName());
        checkBox.setImageResource(com.bytedance.im.ui.R.drawable.icon_im_radio_checked);
        tvUid.setVisibility(View.VISIBLE);
        tvUid.setText("UserID:" + userSelectWrapper.getUser().getUid());
        if (userSelectWrapper.isSelect) {
            checkBox.setImageResource(com.bytedance.im.ui.R.drawable.icon_im_radio_checked);
        } else {
            checkBox.setImageResource(com.bytedance.im.ui.R.drawable.icon_im_radio_unchecked);
        }
    }
}

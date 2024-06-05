package com.bytedance.im.app.live.member.adapter;

import android.view.View;
import android.widget.ImageView;

import androidx.annotation.NonNull;

import com.bytedance.im.app.live.R;


public class VELiveMemberSelectViewHolder extends VELiveMemberViewHolder {

    private ImageView checkBox;

    public VELiveMemberSelectViewHolder(@NonNull View itemView) {
        super(itemView);
        checkBox = itemView.findViewById(R.id.checkbox_user);
    }

    public void bind(VELiveMemberWrapper memberWrapper) {
        super.bind(memberWrapper);
        if (memberWrapper.isSelect) {
            checkBox.setImageResource(R.drawable.icon_im_radio_checked);
        } else {
            checkBox.setImageResource(R.drawable.icon_im_radio_unchecked);
        }
    }
}

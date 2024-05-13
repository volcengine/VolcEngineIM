package com.bytedance.im.app.member.group.adapter;

import android.view.View;
import android.widget.ImageView;

import androidx.annotation.NonNull;

import com.bytedance.im.app.member.R;


public class MemberSelectViewHolder extends MemberViewHolder {

    private ImageView checkBox;

    public MemberSelectViewHolder(@NonNull View itemView) {
        super(itemView);
        checkBox = itemView.findViewById(R.id.checkbox_user);
    }

    public void bind(MemberWrapper memberWrapper) {
        super.bind(memberWrapper);
        if (memberWrapper.isSelect) {
            checkBox.setImageResource(R.drawable.icon_im_radio_checked);
        } else {
            checkBox.setImageResource(R.drawable.icon_im_radio_unchecked);
        }
    }
}

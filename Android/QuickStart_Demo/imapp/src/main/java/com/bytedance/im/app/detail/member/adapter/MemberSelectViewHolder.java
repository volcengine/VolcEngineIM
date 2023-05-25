package com.bytedance.im.app.detail.member.adapter;

import android.support.annotation.NonNull;
import android.view.View;
import android.widget.ImageView;

import com.bytedance.im.app.R;


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

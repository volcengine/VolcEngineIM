package com.bytedance.im.app.live.member.adapter;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.live.R;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;

public class VELiveUserSelectViewHolder extends VELiveBaseSelectViewHolder<VELiveUserSelectWrapper> {
    private ImageView checkBox;
    private ImageView ivHead;
    private TextView tvNickName;
    private TextView tvUid;
    private VELiveUserSelectWrapper selectWrapper;

    public VELiveUserSelectViewHolder(@NonNull View itemView) {
        super(itemView);
        checkBox = itemView.findViewById(R.id.checkbox_user);
        ivHead = itemView.findViewById(R.id.iv_head);
        tvNickName = itemView.findViewById(R.id.tv_nick_name);
        tvUid = itemView.findViewById(R.id.tv_uuid);
    }

    @Override
    protected void bind(VELiveUserSelectWrapper userSelectWrapper) {
        super.bind(userSelectWrapper);
        selectWrapper = userSelectWrapper;
        BIMUIUser user = userSelectWrapper.getInfo();
        Glide.with(ivHead.getContext())
                .load(user.getPortraitUrl())
                .placeholder(R.drawable.icon_recommend_user_default)
                .error(R.drawable.icon_recommend_user_default)
                .into(ivHead);
        tvNickName.setText(BIMUINameUtils.getShowName(user));
        checkBox.setImageResource(R.drawable.icon_im_radio_checked);
        if (userSelectWrapper.isShowUid()) {
            tvUid.setVisibility(View.VISIBLE);
            tvUid.setText("UserID:" + userSelectWrapper.getInfo().getUid());
        } else {
            tvUid.setVisibility(View.GONE);
        }
        if (userSelectWrapper.isSelect) {
            checkBox.setImageResource(R.drawable.icon_im_radio_checked);
        } else {
            checkBox.setImageResource(R.drawable.icon_im_radio_unchecked);
        }
    }
}

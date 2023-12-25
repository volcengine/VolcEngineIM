package com.bytedance.im.app.user;

import android.support.annotation.NonNull;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.R;
import com.bytedance.im.app.utils.VENameUtils;
import com.bytedance.im.user.api.model.BIMUserFullInfo;


public class BIMUserSelectViewHolder extends BaseSelectViewHolder<UserSelectWrapper> {
    private ImageView checkBox;
    private ImageView ivHead;
    private TextView tvNickName;
    private TextView tvUid;
    private UserSelectWrapper selectWrapper;

    public BIMUserSelectViewHolder(@NonNull View itemView) {
        super(itemView);
        checkBox = itemView.findViewById(R.id.checkbox_user);
        ivHead = itemView.findViewById(R.id.iv_head);
        tvNickName = itemView.findViewById(R.id.tv_nick_name);
        tvUid = itemView.findViewById(R.id.tv_uuid);
    }

    @Override
    protected void bind(UserSelectWrapper userSelectWrapper) {
        super.bind(userSelectWrapper);
        selectWrapper = userSelectWrapper;
        BIMUserFullInfo fullInfo = userSelectWrapper.getInfo();
        Glide.with(ivHead.getContext())
                .load(fullInfo.getPortraitUrl())
                .placeholder(R.drawable.icon_recommend_user_default)
                .error(R.drawable.icon_recommend_user_default)
                .into(ivHead);
        tvNickName.setText(VENameUtils.getShowName(fullInfo));
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

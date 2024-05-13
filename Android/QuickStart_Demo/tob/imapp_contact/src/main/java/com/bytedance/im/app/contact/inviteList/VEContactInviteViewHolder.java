package com.bytedance.im.app.contact.inviteList;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;


import com.bytedance.im.app.contact.R;
import com.bytedance.im.app.contact.utils.ContactNameUtils;
import com.bytedance.im.ui.utils.BIMUINameUtils;
import com.bytedance.im.imsdk.contact.user.api.model.BIMFriendApplyInfo;
import com.bytedance.im.imsdk.contact.user.api.model.BIMUserFullInfo;

public class VEContactInviteViewHolder extends RecyclerView.ViewHolder {
    private final ImageView ivHead;
    private BIMFriendApplyInfo data;
    private final TextView tvUid, tvNickName, tvAgree, tvReject, tvIsInvited;
    private InviteContactClickListener listener;

    public VEContactInviteViewHolder(@NonNull View itemView) {
        super(itemView);

        tvUid = itemView.findViewById(R.id.tv_uid);
        ivHead = itemView.findViewById(R.id.iv_head);
        tvAgree = itemView.findViewById(R.id.tv_invite_agree);
        tvNickName = itemView.findViewById(R.id.tv_nick_name);
        tvReject = itemView.findViewById(R.id.tv_invite_reject);
        tvIsInvited = itemView.findViewById(R.id.tv_is_invited);
    }

    public void onBind(BIMFriendApplyInfo data, InviteContactClickListener listener) {
        this.data = data;
        this.listener = listener;
        tvUid.setVisibility(View.GONE);
        BIMUserFullInfo userFullInfo = data.getUserFullInfo();
        tvNickName.setText(ContactNameUtils.getShowName(userFullInfo));

        Glide.with(ivHead.getContext())
                .load(userFullInfo.getPortraitUrl())
                .dontAnimate()
                .placeholder(R.drawable.icon_recommend_user_default)
                .error(R.drawable.icon_recommend_user_default).into(ivHead);
        tvAgree.setOnClickListener(v -> {
            if (null != this.listener) {
                this.listener.onAgree(data);
            }
        });

        tvReject.setOnClickListener(v -> {
            if (null != this.listener) {
                this.listener.onReject(data);
            }
        });

        switch (data.getStatus()) {
            case BIM_FRIEND_STATUS_APPLY: {
                tvAgree.setVisibility(View.VISIBLE);
                tvReject.setVisibility(View.VISIBLE);
                tvIsInvited.setVisibility(View.INVISIBLE);
            } break;
            case BIM_FRIEND_STATUS_AGREE: {
                tvAgree.setVisibility(View.INVISIBLE);
                tvReject.setVisibility(View.INVISIBLE);
                tvIsInvited.setVisibility(View.VISIBLE);
                tvIsInvited.setText("已通过");
            } break;
            case BIM_FRIEND_STATUS_REFUSE: {
                tvAgree.setVisibility(View.INVISIBLE);
                tvReject.setVisibility(View.INVISIBLE);
                tvIsInvited.setVisibility(View.VISIBLE);
                tvIsInvited.setText("已拒绝");
            } break;
            default: {
                tvAgree.setVisibility(View.INVISIBLE);
                tvReject.setVisibility(View.INVISIBLE);
                tvIsInvited.setVisibility(View.INVISIBLE);
            } break;
        }

        ivHead.setOnClickListener(v -> {
            if (listener != null) {
                listener.onPortraitClick(data);
            }
        });
    }
}
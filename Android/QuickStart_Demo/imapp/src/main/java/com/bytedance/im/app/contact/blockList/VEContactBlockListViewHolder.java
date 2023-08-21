package com.bytedance.im.app.contact.blockList;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.user.api.model.BIMFriendApplyInfo;

public class VEContactBlockListViewHolder extends RecyclerView.ViewHolder {
    private final ImageView ivHead;
    private BIMFriendApplyInfo data;
    private final TextView tvNickName;
    private BlockListClickListener listener;

    public VEContactBlockListViewHolder(@NonNull View itemView) {
        super(itemView);

        ivHead = itemView.findViewById(R.id.iv_head);
        tvNickName = itemView.findViewById(R.id.tv_nick_name);
    }

    public void onBind(BIMFriendApplyInfo data, BlockListClickListener listener) {
        this.data = data;
        this.listener = listener;
        tvNickName.setText(String.valueOf(data.getFromUid()));
        ivHead.setImageResource(R.drawable.icon_recommend_user_default);

        if (null != listener) {
            itemView.setOnClickListener(v -> listener.onClick(data));
            itemView.setOnLongClickListener(v -> {
                listener.onLongClick(data);
                return true;
            });
        } else {
            itemView.setOnClickListener(null);
            itemView.setOnLongClickListener(null);
        }
    }
}
package com.bytedance.im.app.contact.blockList;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;

public class VEContactBlockListViewHolder extends RecyclerView.ViewHolder {
    private static String TAG = "VEContactBlockListViewHolder";

    private final ImageView ivHead;
    private VEContactBlackListData data;
    private BlackListClickListener listener;
    private final TextView tvNickName, tvTitle;

    public VEContactBlockListViewHolder(@NonNull View itemView) {
        super(itemView);

        ivHead = itemView.findViewById(R.id.iv_head);
        tvNickName = itemView.findViewById(R.id.tv_nick_name);
        tvTitle = itemView.findViewById(R.id.tv_contact_title);
    }

    public void onBind(VEContactBlackListData data,VEContactBlackListData preData, BlackListClickListener listener) {
        this.data = data;
        this.listener = listener;
        tvNickName.setText(String.valueOf(data.getName()));
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

        if (preData == null || data.getFirstChar() != preData.getFirstChar()) {
            Log.d(TAG, "first char is " + data.getFirstChar());
            tvTitle.setVisibility(View.VISIBLE);
            tvTitle.setText("" + data.getFirstChar());
        } else {
            tvTitle.setVisibility(View.GONE);
        }
    }
}
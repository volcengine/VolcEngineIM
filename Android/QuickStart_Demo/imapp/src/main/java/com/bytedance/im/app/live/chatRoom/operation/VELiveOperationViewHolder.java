package com.bytedance.im.app.live.chatRoom.operation;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.OperationInfo;

public class VELiveOperationViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
    private ImageView icon;
    private TextView name;
    private BIMMessage bimMessage;
    private VELiveOperationAdapter.OnItemOperationClickListener onItemClickListener;
    public VELiveOperationViewHolder(@NonNull View itemView, BIMMessage bimMessage, VELiveOperationAdapter.OnItemOperationClickListener listener) {
        super(itemView);
        icon = itemView.findViewById(com.bytedance.im.ui.R.id.icon);
        name = itemView.findViewById(com.bytedance.im.ui.R.id.name);
        this.bimMessage = bimMessage;
        this.onItemClickListener = listener;
    }

    private OperationInfo mOperationInfo;

    public void update(OperationInfo operationInfo) {
        mOperationInfo = operationInfo;
        if (operationInfo.getResId() == -1) {
            icon.setVisibility(View.GONE);
        } else {
            icon.setImageResource(operationInfo.getResId());
        }
        name.setText(operationInfo.getName());
        itemView.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        mOperationInfo.onClick(v, bimMessage);
        onItemClickListener.onOperationClick();
    }
}

package com.bytedance.im.ui.message.adapter.ui.widget.pop;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;


import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;
import com.bytedance.im.core.api.model.BIMMessage;

public class OperationViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
    private ImageView icon;
    private TextView name;
    private BIMMessage bimMessage;
    private OperationAdapter.OnItemOperationClickListener onItemClickListener;
    public OperationViewHolder(@NonNull View itemView, BIMMessage bimMessage, OperationAdapter.OnItemOperationClickListener listener) {
        super(itemView);
        icon = itemView.findViewById(R.id.icon);
        name = itemView.findViewById(R.id.name);
        this.bimMessage = bimMessage;
        this.onItemClickListener = listener;
    }

    private BIMMessageOperation mOperationInfo;
    public void update(BIMMessageOperation operationInfo) {
        mOperationInfo = operationInfo;
        icon.setImageResource(operationInfo.getResId());
        name.setText(operationInfo.getName());
        itemView.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        mOperationInfo.onClick(v, bimMessage);
        onItemClickListener.onOperationClick();
    }
}

package com.bytedance.im.ui.message.adapter.ui.widget.pop;

import android.content.Intent;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;
import com.bytedance.im.core.api.model.BIMMessage;

import java.util.ArrayList;
import java.util.List;

public class OperationAdapter extends RecyclerView.Adapter<OperationViewHolder> {
    private List<BIMMessageOperation> operationInfoList = new ArrayList<>();
    private BIMMessage bimMessage;
    private OnItemOperationClickListener onItemOperationClickListener;

    public OperationAdapter(List<BIMMessageOperation> operationInfoList, BIMMessage bimMessage, OnItemOperationClickListener onItemOperationClickListener) {
        this.operationInfoList = operationInfoList;
        this.bimMessage = bimMessage;
        this.onItemOperationClickListener = onItemOperationClickListener;
    }

    @NonNull
    @Override
    public OperationViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.bim_im_item_option_layout, viewGroup, false);
        return new OperationViewHolder(v, bimMessage, onItemOperationClickListener);
    }

    @Override
    public void onBindViewHolder(@NonNull OperationViewHolder operationViewHolder, int i) {
        operationViewHolder.update(operationInfoList.get(i));
    }

    @Override
    public int getItemCount() {
        return operationInfoList.size();
    }

    public interface OnItemOperationClickListener {
        void onOperationClick();
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (operationInfoList != null) {
            for (BIMMessageOperation info : operationInfoList) {
                info.onActivityResult(requestCode, resultCode, data);
            }
        }
    }
}

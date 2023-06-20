package com.bytedance.im.app.live.chatRoom.operation;

import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.OperationInfo;

import java.util.ArrayList;
import java.util.List;

public class VELiveOperationAdapter extends RecyclerView.Adapter<VELiveOperationViewHolder> {
    private List<OperationInfo> operationInfoList = new ArrayList<>();
    private BIMMessage bimMessage;
    private VELiveOperationAdapter.OnItemOperationClickListener onItemOperationClickListener;

    public VELiveOperationAdapter(List<OperationInfo> operationInfoList, BIMMessage bimMessage, VELiveOperationAdapter.OnItemOperationClickListener onItemOperationClickListener) {
        this.operationInfoList = operationInfoList;
        this.bimMessage = bimMessage;
        this.onItemOperationClickListener = onItemOperationClickListener;
    }

    @NonNull
    @Override
    public VELiveOperationViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.ve_im_live_item_option_layout, viewGroup, false);
        return new VELiveOperationViewHolder(v, bimMessage, onItemOperationClickListener);
    }

    @Override
    public void onBindViewHolder(@NonNull VELiveOperationViewHolder operationViewHolder, int i) {
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
            for (OperationInfo info : operationInfoList) {
                info.onActivityResult(requestCode, resultCode, data);
            }
        }
    }
}

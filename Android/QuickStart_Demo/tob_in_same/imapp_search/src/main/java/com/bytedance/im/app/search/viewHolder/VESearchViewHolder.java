package com.bytedance.im.app.search.viewHolder;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import android.view.View;

import com.bytedance.im.app.search.interfaces.OnSearchMsgClickListener;

public class VESearchViewHolder<T> extends RecyclerView.ViewHolder {
    protected OnSearchMsgClickListener onSearchMsgClickListener;

    public VESearchViewHolder(@NonNull View itemView) {
        super(itemView);
    }

    public void bind(T t) {

    }

    public void setOnSearchMsgClickListener(OnSearchMsgClickListener onSearchMsgClickListener) {
        this.onSearchMsgClickListener = onSearchMsgClickListener;
    }
}

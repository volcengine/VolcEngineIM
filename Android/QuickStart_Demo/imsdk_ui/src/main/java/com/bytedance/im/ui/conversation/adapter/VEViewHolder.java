package com.bytedance.im.ui.conversation.adapter;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;

public class VEViewHolder<T> extends RecyclerView.ViewHolder {
    private T t;

    public VEViewHolder(@NonNull View itemView) {
        super(itemView);
    }

    public void bind(T t) {
        this.t = t;
    }

    public T getWrapperInfo() {
        return t;
    }
}

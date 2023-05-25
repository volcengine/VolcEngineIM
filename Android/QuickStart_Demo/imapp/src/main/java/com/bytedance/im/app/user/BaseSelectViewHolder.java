package com.bytedance.im.app.user;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;


public class BaseSelectViewHolder<T> extends RecyclerView.ViewHolder {
    public BaseSelectViewHolder(@NonNull View itemView) {
        super(itemView);
    }

    protected void bind(T t) {

    }
}

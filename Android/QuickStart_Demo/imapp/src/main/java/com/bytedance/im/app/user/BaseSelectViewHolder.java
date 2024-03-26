package com.bytedance.im.app.user;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;


public class BaseSelectViewHolder<T> extends RecyclerView.ViewHolder {
    public BaseSelectViewHolder(@NonNull View itemView) {
        super(itemView);
    }

    protected void bind(T t) {

    }
}

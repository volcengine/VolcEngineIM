package com.bytedance.im.app.search.media.viewholder;

import android.view.View;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;

public class VEMediaVideoViewHolder extends VEMediaBaseViewHolder {
    public ImageView imageView;

    public VEMediaVideoViewHolder(@NonNull View itemView) {
        super(itemView);
        imageView = itemView.findViewById(R.id.img);
    }
}

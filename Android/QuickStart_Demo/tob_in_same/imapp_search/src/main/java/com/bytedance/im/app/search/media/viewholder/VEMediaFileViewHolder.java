package com.bytedance.im.app.search.media.viewholder;

import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;

public class VEMediaFileViewHolder extends VEMediaBaseViewHolder {
    public TextView tvTitle;
    public TextView tvDesc;
    public TextView tvTime;
    public TextView tvSize;
    public VEMediaFileViewHolder(@NonNull View itemView) {
        super(itemView);
        tvTitle = itemView.findViewById(R.id.tv_title);
        tvDesc = itemView.findViewById(R.id.tv_desc);
        tvTime = itemView.findViewById(R.id.tv_time);
        tvSize = itemView.findViewById(R.id.tv_file_size);
    }
}

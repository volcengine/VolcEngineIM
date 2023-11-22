package com.bytedance.im.ui.message.adapter.ui.widget.input.tools.adapter;

import android.app.Fragment;
import android.support.annotation.NonNull;

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;

public class ToolViewHolder extends RecyclerView.ViewHolder {
    private ImageView icon;
    private TextView title;

    public ToolViewHolder(@NonNull View itemView) {
        super(itemView);
        icon = itemView.findViewById(R.id.iv_input_optional_icon);
        title = itemView.findViewById(R.id.tv_input_optional_title);

    }

    public void bind(BaseToolBtn baseToolBtn) {
        icon.setImageResource(baseToolBtn.getIcon(icon.getContext()));
        title.setText(baseToolBtn.getTitle(title.getContext()));
    }
}

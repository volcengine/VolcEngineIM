package com.bytedance.im.ui.message.adapter.ui.widget.input.tools.adapter;

import android.app.Fragment;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;

import java.util.List;

public class ToolListAdapter extends RecyclerView.Adapter<ToolViewHolder> {
    public List<BaseToolBtn> data;
    private Fragment fragment;
    private BIMConversation conversation;

    public ToolListAdapter(Fragment fragment, BIMConversation conversation, List<BaseToolBtn> data) {
        this.data = data;
        this.fragment = fragment;
        this.conversation = conversation;
    }

    @NonNull
    @Override
    public ToolViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = View.inflate(viewGroup.getContext(), R.layout.bim_im_input_btn_item, null);
        return new ToolViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull ToolViewHolder toolViewHolder, int i) {
        BaseToolBtn baseToolBtn = data.get(i);
        toolViewHolder.bind(baseToolBtn);
        toolViewHolder.itemView.setOnClickListener(v -> baseToolBtn.onClick(fragment, v, conversation));
    }

    @Override
    public int getItemCount() {
        return data.size();
    }
}

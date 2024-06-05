package com.bytedance.im.app.search;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.search.model.VESearchDivWrapper;
import com.bytedance.im.app.search.model.VESearchWrapper;
import com.bytedance.im.app.search.interfaces.OnSearchMsgClickListener;
import com.bytedance.im.app.search.viewHolder.VESearchDivViewHolder;
import com.bytedance.im.app.search.viewHolder.VESearchFileMsgViewHolder;
import com.bytedance.im.app.search.viewHolder.VESearchMsgViewHolder;
import com.bytedance.im.app.search.viewHolder.VESearchViewHolder;

import java.util.ArrayList;
import java.util.List;

public class VESearchAdapter extends RecyclerView.Adapter<VESearchViewHolder> {
    private List<VESearchWrapper> data = new ArrayList<>();
    private OnSearchMsgClickListener listener;

    public VESearchAdapter(OnSearchMsgClickListener listener) {
        this.listener = listener;
    }

    @NonNull
    @Override
    public VESearchViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int type) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(type, viewGroup, false);
        VESearchViewHolder viewHolder = null;
        if (type == R.layout.ve_im_item_media_file_layout) {
            viewHolder = new VESearchFileMsgViewHolder(view);
        } else if (type == R.layout.ve_im_item_search_msg_layout) {
            VESearchMsgViewHolder v = new VESearchMsgViewHolder(view);
            viewHolder = v;
        } else if (type == R.layout.ve_im_item_search_div_layout) {
            viewHolder = new VESearchDivViewHolder(view);
        }
        viewHolder.setOnSearchMsgClickListener(listener);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull VESearchViewHolder veSearchViewHolder, int i) {
        veSearchViewHolder.bind(data.get(i));
    }

    public void appendData(List<VESearchWrapper> appendData) {
        if (appendData != null) {
            data.addAll(appendData);
            notifyDataSetChanged();
        }
    }

    @Override
    public int getItemViewType(int position) {
        return data.get(position).getLayoutId();
    }

    @Override
    public int getItemCount() {
        return data.size();
    }
}

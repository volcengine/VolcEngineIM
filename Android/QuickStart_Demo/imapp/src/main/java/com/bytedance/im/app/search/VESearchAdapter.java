package com.bytedance.im.app.search;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.app.R;
import com.bytedance.im.app.search.data.VESearchWrapper;
import com.bytedance.im.app.search.interfaces.OnSearchMsgClickListener;
import com.bytedance.im.app.search.viewHolder.VESearchDivViewHolder;
import com.bytedance.im.app.search.viewHolder.VESearchMsgViewHolder;
import com.bytedance.im.app.search.viewHolder.VESearchViewHolder;

import java.util.List;

public class VESearchAdapter extends RecyclerView.Adapter<VESearchViewHolder> {
    private List<VESearchWrapper> data;
    private OnSearchMsgClickListener listener;

    public VESearchAdapter(List<VESearchWrapper> data, OnSearchMsgClickListener listener) {
        this.data = data;
        this.listener = listener;
    }

    @NonNull
    @Override
    public VESearchViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int type) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(type, viewGroup, false);
        VESearchViewHolder viewHolder = null;
        if (type == R.layout.ve_im_item_search_msg_layout) {
            VESearchMsgViewHolder v = new VESearchMsgViewHolder(view);
            v.setListener(listener);
            viewHolder = v;
        } else if (type == R.layout.ve_im_item_search_div_layout) {
            viewHolder = new VESearchDivViewHolder(view);
        }
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull VESearchViewHolder veSearchViewHolder, int i) {
        veSearchViewHolder.bind(data.get(i));
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

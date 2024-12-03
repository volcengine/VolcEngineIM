package com.bytedance.im.app.search.global.message.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;

import java.util.ArrayList;
import java.util.List;

public class SearchMessageGlobalAdapter extends RecyclerView.Adapter<SearchMsgGViewHolder> {
    private List<SearchMsgGWrapper> data;
    private OnItemClickListener onItemClickListener;

    public SearchMessageGlobalAdapter() {
        this.data = new ArrayList<>();
    }

    @NonNull
    @Override
    public SearchMsgGViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_im_item_search_msg_global_layout, parent, false);
        return new SearchMsgGViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull SearchMsgGViewHolder holder, int position) {

        holder.itemView.setOnClickListener(v -> {
            if (onItemClickListener != null) {
                onItemClickListener.onItemClick(data.get(position));
            }
        });
        holder.update(data.get(position));
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public void appendData(List<SearchMsgGWrapper> list) {
        data.addAll(list);
        notifyDataSetChanged();
    }

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    public interface OnItemClickListener {
        void onItemClick(SearchMsgGWrapper wrapper);
    }
}

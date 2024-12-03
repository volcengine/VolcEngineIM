package com.bytedance.im.app.search.global.group.adapter;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.group.model.SearchGroupGWrapper;

import java.util.ArrayList;
import java.util.List;

public class SearchGlobalGroupAdapter extends RecyclerView.Adapter<SearchGroupGViewHolder> {
    private List<SearchGroupGWrapper> data = new ArrayList();
    private OnItemClickListener listener;

    public SearchGlobalGroupAdapter(OnItemClickListener listener) {
        this.listener = listener;
    }

    @NonNull
    @Override
    public SearchGroupGViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_im_item_search_group, parent, false);
        return new SearchGroupGViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull SearchGroupGViewHolder holder, int position) {
        SearchGroupGWrapper info = data.get(position);
        holder.itemView.setOnClickListener(v -> {
            if (listener != null) {
                listener.onItemClick(info);
            }
        });
        holder.update(info);
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public void appendData(List<SearchGroupGWrapper> appendList) {
        data.addAll(appendList);
        notifyDataSetChanged();
    }

    public interface OnItemClickListener {
        void onItemClick(SearchGroupGWrapper info);
    }
}


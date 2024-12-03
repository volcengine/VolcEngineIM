package com.bytedance.im.app.search.global.member.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.member.model.SearchConvMeGWrapper;

import java.util.ArrayList;
import java.util.List;

public class SearchConvMemberAdapter extends RecyclerView.Adapter<SearchConvMemberViewHolder> {
    List<SearchConvMeGWrapper> data = new ArrayList<>();
    private OnItemClickListener listener;

    public SearchConvMemberAdapter(OnItemClickListener listener) {
        this.listener = listener;
    }

    @NonNull
    @Override
    public SearchConvMemberViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_im_item_search_member, parent, false);
        return new SearchConvMemberViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull SearchConvMemberViewHolder holder, int position) {
        holder.bind(data.get(position));
        holder.itemView.setOnClickListener(v -> {
            if (listener != null) {
                listener.onItemClick(data.get(position));
            }
        });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public void appendData(List<SearchConvMeGWrapper> list) {
        data.addAll(list);
        notifyDataSetChanged();
    }

    public interface OnItemClickListener {
        void onItemClick(SearchConvMeGWrapper wrapper);
    }
}

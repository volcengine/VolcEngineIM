package com.bytedance.im.app.search.global.contact.dapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.contact.model.SearchFriendGWrapper;

import java.util.ArrayList;
import java.util.List;

public class SearchFriendAdapter extends RecyclerView.Adapter<SearchFriendGViewHolder> {
    List<SearchFriendGWrapper> data = new ArrayList<>();
    private OnItemClickListener onItemClickListener;

    public SearchFriendAdapter(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    @NonNull
    @Override
    public SearchFriendGViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_im_item_search_friend, parent, false);
        return new SearchFriendGViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull SearchFriendGViewHolder holder, int position) {
        holder.update(data.get(position));
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onItemClickListener != null) {
                    onItemClickListener.onItemClick(data.get(position));
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public void appendData(List<SearchFriendGWrapper> fList) {
        data.addAll(fList);
        notifyDataSetChanged();
    }

    public interface OnItemClickListener {
        void onItemClick(SearchFriendGWrapper friendGWrapper);
    }
}

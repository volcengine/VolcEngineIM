package com.bytedance.im.app.profile;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.List;

public class PortraitAdapter extends RecyclerView.Adapter<PortraitViewHolder> {
    private List<String> data = new ArrayList<>();
    private OnItemClickListener listener;

    interface OnItemClickListener {
        void onItemClick(String url);
    }

    public PortraitAdapter(List<String> data, OnItemClickListener listener) {
        this.data = data;
        this.listener = listener;
    }

    @NonNull
    @Override
    public PortraitViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.ve_im_item_edit_portrait, viewGroup, false);
        return new PortraitViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull PortraitViewHolder portraitViewHolder, int i) {
        ImageView ivPortrait = portraitViewHolder.itemView.findViewById(R.id.iv_portrait);
        Glide.with(ivPortrait.getContext())
                .load(data.get(i))
                .dontAnimate()
                .placeholder(R.drawable.icon_recommend_user_default)
                .into(ivPortrait);
        portraitViewHolder.itemView.setOnClickListener(v -> {
            if (listener != null) {
                listener.onItemClick(data.get(i));
            }
        });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }
}

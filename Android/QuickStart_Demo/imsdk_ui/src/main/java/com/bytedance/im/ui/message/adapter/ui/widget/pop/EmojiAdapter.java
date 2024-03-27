package com.bytedance.im.ui.message.adapter.ui.widget.pop;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.emoji.EmojiInfo;

import java.util.ArrayList;
import java.util.List;

public class EmojiAdapter extends RecyclerView.Adapter<EmojiViewHolder> {
    private List<EmojiInfo> emojis = new ArrayList<>();
    private OnClickListener listener;

    @NonNull
    @Override
    public EmojiViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.bim_im_item_emoji, viewGroup, false);
        return new EmojiViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull EmojiViewHolder emojiViewHolder, int i) {
        EmojiInfo emojiInfo = this.emojis.get(i);
        emojiViewHolder.bind(emojiInfo);
        emojiViewHolder.itemView.setOnClickListener(v -> {
            if (listener != null) {
                listener.onClick(v, emojiInfo);
            }
        });
    }

    public void updateData(List<EmojiInfo> newEmojis) {
        this.emojis.clear();
        this.emojis.addAll(newEmojis);
        this.notifyDataSetChanged();
    }

    @Override
    public int getItemCount() {
        return this.emojis.size();
    }

    public void setOnClickListener(OnClickListener listener) {
        this.listener = listener;
    }

    interface OnClickListener {
        void onClick(View v, EmojiInfo emojiInfo);
    }
}
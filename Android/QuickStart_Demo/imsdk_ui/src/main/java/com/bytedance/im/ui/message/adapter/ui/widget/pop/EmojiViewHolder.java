package com.bytedance.im.ui.message.adapter.ui.widget.pop;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.emoji.EmojiInfo;

class EmojiViewHolder extends RecyclerView.ViewHolder {
    private ImageView imageView;

    public EmojiViewHolder(@NonNull View itemView) {
        super(itemView);
        imageView = itemView.findViewById(R.id.iv_main);
    }

    public void bind(EmojiInfo emojiInfo) {
        imageView.setImageResource(emojiInfo.resId);
        if (emojiInfo.code == EmojiInfo.CODE_OPEN) {
            imageView.setScaleX(0.8f);
            imageView.setScaleY(0.8f);
        } else {
            imageView.setScaleX(1f);
            imageView.setScaleY(1f);
        }
    }
}
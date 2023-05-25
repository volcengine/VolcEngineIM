package com.bytedance.im.ui.message.adapter.ui.widget;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.emoji.EmojiInfo;


public class EmojiGridAdapter extends BaseListAdapter<EmojiInfo> {

    private LayoutInflater mInflater;

    public EmojiGridAdapter(Context context) {
        super(context);
        mInflater = LayoutInflater.from(context);
    }

    @Override
    public View getView(int pos, View view, ViewGroup viewGroup) {
        EmojiInfo emotionInfo = getItem(pos);
        if (view == null) {
            view = mInflater.inflate(R.layout.bim_grid_item_emoji, viewGroup, false);
        }
        ImageView imageView = (ImageView) view;
        imageView.setImageResource(emotionInfo.resId);
        return view;
    }
}

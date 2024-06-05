package com.bytedance.im.app.search.tab;

import android.app.Fragment;
import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.bytedance.im.app.search.R;
import com.bytedance.im.core.api.enums.BIMMessageType;

public class SearchTab extends FrameLayout {
    private TextView textView;
    private View indicator;
    private String title;
    private BIMMessageType messageType;
    private Fragment fragment;

    public SearchTab(@NonNull Context context, String title, BIMMessageType messageType, Fragment f) {
        super(context);
        inflate(context, R.layout.ve_im_tab_search_item, this);
        textView = findViewById(R.id.tab_tv);
        indicator = findViewById(R.id.indicator);
        this.title = title;
        textView.setText(title);
        indicator.setBackgroundColor(Color.TRANSPARENT);
        this.messageType = messageType;
        fragment = f;
    }

    public void updateSelect(SearchTab searchTab) {
        if (this == searchTab) {
            indicator.setBackgroundColor(Color.BLUE);
            textView.setTextColor(Color.BLUE);
        } else {
            indicator.setBackgroundColor(Color.TRANSPARENT);
            textView.setTextColor(Color.BLACK);
        }
    }

    public String getTitle() {
        return title;
    }

    public BIMMessageType getMessageType() {
        return messageType;
    }

    public Fragment getFragment() {
        return fragment;
    }
}

package com.bytedance.im.app.plugins.widget;

import android.content.Context;
import android.graphics.Color;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bytedance.im.app.R;
import com.bytedance.im.ui.api.interfaces.BIMUnreadListener;

public class TabView extends FrameLayout implements BIMUnreadListener {
    private static int SELECTED_COLOR = 0xFF9770FF;
    private static int UNSELECTED_COLOR = Color.BLACK;
    private ImageView icon;
    private TextView title;
    private TextView unRead;

    public TabView(@NonNull Context context) {
        super(context);
        init(context);
    }

    public TabView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public TabView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }


    private void init(Context context) {
        LayoutInflater.from(context).inflate(R.layout.ve_im_tab_item, this, true);
        icon = findViewById(R.id.iv_icon);
        title = findViewById(R.id.tv_title);
        unRead = findViewById(R.id.tv_unread);
    }

    public void updateTitleColor(TabView curSelect) {
        title.setTextColor(curSelect == this ? SELECTED_COLOR : UNSELECTED_COLOR);
    }

    public void setTitle(String t) {
        title.setText(t);
    }

    public void setIcon(int res) {
        icon.setImageResource(res);
    }

    @Override
    public void onUnreadChanged(int unreadCount) {
        if (unreadCount > 99) {
            unRead.setText("99+");
        } else {
            unRead.setText(String.valueOf(unreadCount));
        }
        if (unreadCount > 0) {
            unRead.setVisibility(View.VISIBLE);
        } else {
            unRead.setVisibility(View.GONE);
        }
    }
}

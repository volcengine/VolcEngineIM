package com.bytedance.im.ui.message.adapter.ui.widget.input.measure;

import android.content.Context;
import androidx.annotation.NonNull;
import android.widget.FrameLayout;

public class MeasureLayout extends FrameLayout {
    private int height;
    private onHeightChangedListener listener;

    public MeasureLayout(@NonNull Context context, onHeightChangedListener listener) {
        super(context);
        this.listener = listener;
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);
        long c = bottom - top;
        if (height != c) {
            height = (bottom - top);
            listener.onHeightChanged(height);
        }

    }

    interface onHeightChangedListener {
        void onHeightChanged(int height);
    }
}

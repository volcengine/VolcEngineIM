package com.bytedance.im.ui.message;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.AttributeSet;
import android.view.MotionEvent;

public class BIMMessageRecyclerView extends RecyclerView {
    private static final String TAG = "VEMessageRecyclerView";

    public interface OnDispatchListener {
        boolean dispatchTouchEvent(MotionEvent ev);
    }

    private OnDispatchListener onDispatchListener;

    public BIMMessageRecyclerView(@NonNull Context context) {
        super(context);
    }

    public BIMMessageRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    public BIMMessageRecyclerView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        super.onLayout(changed, l, t, r, b);
        LinearLayoutManager linearLayoutManager = (LinearLayoutManager) getLayoutManager();
        int range = computeVerticalScrollRange();
        int measureHeight = getMeasuredHeight();
        if (range > 0 && range < measureHeight) {
            linearLayoutManager.offsetChildrenVertical(range - measureHeight);
        } else {
            linearLayoutManager.offsetChildrenVertical(0);
        }
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        if (onDispatchListener != null) {
            onDispatchListener.dispatchTouchEvent(ev);
        }
        return super.dispatchTouchEvent(ev);
    }


    public void setOnDispatchListener(OnDispatchListener onDispatchListener) {
        this.onDispatchListener = onDispatchListener;
    }
}

package com.bytedance.im.ui.message.adapter;

import android.animation.ArgbEvaluator;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;

public class DynamicGradientDrawable extends GradientDrawable {
    private int startColor;
    private int endColor;
    private ArgbEvaluator argbEvaluator = new ArgbEvaluator();
    private RecyclerView recyclerView;
    private View itemView;
    private View targetView;

    /**
     * @param recyclerView
     * @param itemView
     * @param targetView   要设置背景的 targetView
     */
    public DynamicGradientDrawable(RecyclerView recyclerView, View itemView, View targetView) {
        startColor = Color.BLUE;
        endColor = Color.YELLOW;
        setShape(RECTANGLE);
        setOrientation(Orientation.TOP_BOTTOM);
        setCornerRadius(20f);
        this.recyclerView = recyclerView;
        this.itemView = itemView;
        this.targetView = targetView;
        if (itemView != null && recyclerView != null && targetView != null) {
            recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
                @Override
                public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                    super.onScrolled(recyclerView, dx, dy);
                    refreshColor();
                }
            });
        }
    }

    public void refreshColor() {
        if (recyclerView == null || itemView == null || targetView == null) {
            return;
        }
        int recyclerViewHeight = recyclerView.getHeight();
        int t = Math.max(itemView.getTop(), targetView.getTop());
        int b = Math.min(t + targetView.getHeight(), recyclerViewHeight);
        t = Math.max(t, 0);
        if (b < 0) return;
        int start = (int) argbEvaluator.evaluate((float) t / recyclerViewHeight, startColor, endColor);
        int end = (int) argbEvaluator.evaluate((float) b / recyclerViewHeight, startColor, endColor);
        setColors(new int[]{start, end});
    }
}

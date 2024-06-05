package com.bytedance.im.app.live.utils;

import androidx.recyclerview.widget.RecyclerView;

public class VELiveUtils {
    private static final String TAG = "VELiveUtils";

    public static boolean isScrollToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        if (recyclerView.computeVerticalScrollOffset() == 0) {
            return false;
        }
        if (recyclerView.computeVerticalScrollExtent() + recyclerView.computeVerticalScrollOffset()
                >= recyclerView.computeVerticalScrollRange())
            return true;
        return false;
    }
}

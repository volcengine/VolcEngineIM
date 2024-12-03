package com.bytedance.im.app.search;

import android.graphics.Color;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;

import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchPosition;

import java.util.List;

public class SearchUIUtils {
    public static boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        return !recyclerView.canScrollVertically(1);
    }


    public static SpannableString getSearchSpanString(BIMSearchDetail searchDetail, String defaultStr) {
        if (TextUtils.isEmpty(defaultStr)) {
            defaultStr = "";
        }
        if (searchDetail == null) {
            return new SpannableString(defaultStr);
        }
        List<BIMSearchPosition> positionList = searchDetail.getKeyPositions();
        String searchContent = searchDetail.getSearchContent();
        SpannableString spannableString = new SpannableString(searchContent);
        for (BIMSearchPosition pos : positionList) {
            spannableString.setSpan(new ForegroundColorSpan(Color.GREEN), pos.getStart(), pos.getEnd(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        }
        return spannableString;
    }
}

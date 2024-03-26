package com.bytedance.im.ui.message.adapter.ui.widget;

import androidx.viewpager.widget.PagerAdapter;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

public class ViewPagerAdapter extends PagerAdapter {

    List<View> viewList = new ArrayList<>();

    public void setViewList(List<View> list) {
        viewList = list;
        if (viewList == null) {
            viewList = new ArrayList<>();
        }
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return viewList.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object o) {
        return view == o;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView(viewList.get(position));
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        container.addView(viewList.get(position));
        return viewList.get(position);
    }

    public View getViewItem(int position) {
        return (position < 0 || position >= viewList.size()) ? null : viewList.get(position);
    }
}

package com.bytedance.im.ui.message.adapter.ui.widget.input.tools.adapter;

import android.app.Fragment;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.v4.view.PagerAdapter;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;

import java.util.ArrayList;
import java.util.List;

public class ToolPageAdapter extends PagerAdapter {
    private static final int ONE_PAGE_TOOL_COUNT = 8;

    private List<BaseToolBtn> toolBtnList;

    private List<RecyclerView> eachPageViewList;
    private BIMConversation conversation;


    public ToolPageAdapter(Fragment fragment, BIMConversation conversation, List<BaseToolBtn> list) {
        toolBtnList = list;
        eachPageViewList = new ArrayList<>();
        this.conversation = conversation;
        List<BaseToolBtn> pageList = new ArrayList<>();
        for (int i = 0; i < toolBtnList.size(); i++) {
            pageList.add(toolBtnList.get(i));
            if (i % ONE_PAGE_TOOL_COUNT == 7) {
                eachPageViewList.add(createPageView(fragment, pageList));
                pageList = new ArrayList<>();
            }
        }
        if (!pageList.isEmpty()) {
            eachPageViewList.add(createPageView(fragment, pageList));
        }
    }

    private RecyclerView createPageView(Fragment fragment, List<BaseToolBtn> list) {
        RecyclerView view = (RecyclerView) LayoutInflater.from(fragment.getActivity()).inflate(R.layout.bim_im_input_tool_list, null);
        view.setLayoutManager(new GridLayoutManager(fragment.getActivity(), 4));
        view.setAdapter(new ToolListAdapter(fragment, conversation, list));
        return view;
    }

    @Override
    public int getCount() {
        return eachPageViewList.size();
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object o) {
        return view == o;
    }

    @Override
    public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
        container.removeView((View) object);
    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, int position) {
        View v = eachPageViewList.get(position);
        container.addView(v);
        return v;
    }
}

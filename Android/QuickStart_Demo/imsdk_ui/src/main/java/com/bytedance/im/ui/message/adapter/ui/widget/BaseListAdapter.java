package com.bytedance.im.ui.message.adapter.ui.widget;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.ArrayList;
import java.util.List;

public abstract class BaseListAdapter<T> extends BaseAdapter {

    public List<T> mDataList = new ArrayList<T>();
    protected Context mContext;

    public BaseListAdapter(Context context) {
        mContext = context;
    }

    public void setDataList(List<T> list) {
        if (list == null) {
            mDataList = new ArrayList<T>();
        } else {
            mDataList = list;
        }
        notifyDataSetChanged();
    }

    public List<T> getDataList() {
        return mDataList;
    }

    @Override
    public abstract View getView(int pos, View view, ViewGroup viewGroup);

    @Override
    public long getItemId(int pos) {
        return pos;
    }

    @Override
    public T getItem(int pos) {
        return (pos >= 0 && pos < getCount() ? mDataList.get(pos) : null);
    }

    @Override
    public int getCount() {
        return mDataList != null ? mDataList.size() : 0;
    }
}

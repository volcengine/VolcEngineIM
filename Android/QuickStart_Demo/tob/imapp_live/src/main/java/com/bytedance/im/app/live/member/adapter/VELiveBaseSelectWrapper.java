package com.bytedance.im.app.live.member.adapter;

public class VELiveBaseSelectWrapper<T> {
    protected int layoutId;
    protected boolean isSelect;
    protected T t;

    public int getLayoutId() {
        return layoutId;
    }

    public boolean isSelect() {
        return isSelect;
    }

    public T getInfo() {
        return t;
    }
}

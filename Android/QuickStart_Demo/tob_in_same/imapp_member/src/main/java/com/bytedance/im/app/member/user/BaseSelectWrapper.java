package com.bytedance.im.app.member.user;

public class BaseSelectWrapper<T> {
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

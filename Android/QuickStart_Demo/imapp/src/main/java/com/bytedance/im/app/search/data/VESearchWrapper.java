package com.bytedance.im.app.search.data;

public class VESearchWrapper<T> {
    private T t;
    int layoutId;

    public VESearchWrapper(int layoutId,T t) {
        this.layoutId = layoutId;
        this.t = t;
    }

    public T getInfo() {
        return t;
    }

    public int getLayoutId() {
        return layoutId;
    }
}

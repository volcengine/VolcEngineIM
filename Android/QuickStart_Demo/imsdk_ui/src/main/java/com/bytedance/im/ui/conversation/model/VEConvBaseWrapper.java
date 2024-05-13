package com.bytedance.im.ui.conversation.model;

/**
 * 业务模型
 *
 * @param <T>
 */
public class VEConvBaseWrapper<T> {
    private int layoutId;
    public VEConvBaseWrapper(T t, int type) {
        this.t = t;
        this.layoutId = type;
    }

    T t;

    //一些业务字段
    boolean isCheck;
    boolean isHighlight;

    public int getType() {
        return layoutId;
    }

    public T getInfo() {
        return t;
    }

    public long getSortOrder(){
        return 0;
    }

    public String getConversationId(){
        return "";
    }
}

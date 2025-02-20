package com.bytedance.im.ui.conversation.model;

/**
 * 业务模型
 *
 * @param <T>
 */
public class VEConvBaseWrapper<T> {
    protected long ORDER_TOP_STRANGE = Long.MAX_VALUE;
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

    public long getConversationShortId() {
        return 0L;
    }

    public String getConversationId(){
        return "";
    }
}

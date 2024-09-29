package com.bytedance.im.ui.message.convert.base.ui;

import android.view.View;

import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.core.api.model.BIMMessage;

public abstract class BaseCustomElementUI {
    /**
     * 获取布局
     * @return
     */
    public abstract int getLayoutId();

    /**
     * 绑定View
     * @param v
     * @param messageWrapper
     * @param preMessageWrapper
     */
    public abstract void onBindView(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper);

    /**
     * 点击监听
     * @param v
     * @param messageWrapper
     */
    public abstract void onClick(BIMMessageViewHolder holder,View v, BIMMessageWrapper messageWrapper);

    /**
     * 复制内容
     * @param bimMessage
     * @return
     */
    public CharSequence getCopy(BIMMessage bimMessage){
        return "";
    }

    /**
     * 卡片是否居中
     * @return
     */
    public boolean needHorizonCenterParent() {
        return false;
    }

    /**
     * 是否隐藏头像
     * @return
     */
    public boolean needPortraitGone() {
        return false;
    }

    /**
     * 是否展示复制按钮
     * @param bimMessage
     * @return
     */
    public boolean isEnableCopy(BIMMessage bimMessage) {
        return false;
    }

    /**
     * 是否展示删除按钮
     * @param bimMessage
     * @return
     */
    public boolean isEnableDelete(BIMMessage bimMessage) {
        return true;
    }

    /**
     * 是否展示撤回按钮
     * @param bimMessage
     * @return
     */
    public boolean isEnableRecall(BIMMessage bimMessage) {
        return false;
    }

    /**
     * 是否展示引用按钮
     * @param bimMessage
     * @return
     */
    public boolean isEnableRef(BIMMessage bimMessage) {
        return false;
    }

    /**
     * 是否支持编辑消息
     *
     * @param bimMessage
     * @return
     */
    public boolean isEnableEdit(BIMMessage bimMessage) {
        return false;
    }

    /**
     * 是否支持消息回执展示
     *
     * @param bimMessage
     * @return
     */
    public boolean isEnableReceipt(BIMMessage bimMessage) {
        return true;
    }

    /**
     * 是否展示重发按钮
     * @return
     */
    public boolean isForceStatusGone(){
        return false;
    }
}

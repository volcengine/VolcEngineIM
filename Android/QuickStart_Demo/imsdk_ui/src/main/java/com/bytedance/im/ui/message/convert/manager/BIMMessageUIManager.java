package com.bytedance.im.ui.message.convert.manager;

import android.util.Log;

import com.bytedance.im.core.model.inner.msg.BIMBaseElement;
import com.bytedance.im.ui.message.adapter.ui.inner.CustomMessageDefaultUI;
import com.bytedance.im.ui.message.adapter.ui.inner.DefaultMessageUI;
import com.bytedance.im.ui.message.adapter.ui.inner.FileMessageUI;
import com.bytedance.im.ui.message.adapter.ui.inner.ImageMessageUI;
import com.bytedance.im.ui.message.adapter.ui.inner.PoiMessageUI;
import com.bytedance.im.ui.message.adapter.ui.inner.StreamMessageUI;
import com.bytedance.im.ui.message.adapter.ui.inner.SystemMessageUI;
import com.bytedance.im.ui.message.adapter.ui.inner.TextMessageUI;
import com.bytedance.im.ui.message.adapter.ui.inner.VideoMessageUI;
import com.bytedance.im.ui.message.adapter.ui.inner.VoiceMessageUI;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;

import java.lang.annotation.Annotation;
import java.util.HashMap;

public class BIMMessageUIManager {
    private static final String TAG = "VEMessageUIManager";

    private static class SingleHolder {
        private static final BIMMessageUIManager instance = new BIMMessageUIManager();
    }

    public BIMMessageUIManager() {

    }

    /**
     * 获取 MessageUI 管理类单例
     * @return
     */
    public static BIMMessageUIManager getInstance() {
        return SingleHolder.instance;
    }

    /**
     * 初始化接口
     */
    public void init() {
        registerMessageUI(new TextMessageUI());
        registerMessageUI(new StreamMessageUI());
        registerMessageUI(new VideoMessageUI());
        registerMessageUI(new ImageMessageUI());
        registerMessageUI(new VoiceMessageUI());
        registerMessageUI(new FileMessageUI());
        registerMessageUI(new PoiMessageUI());
        registerMessageUI(new SystemMessageUI());
        registerMessageUI(new DefaultMessageUI());
        registerMessageUI(new CustomMessageDefaultUI());
    }

    private final HashMap<Class<?>, BaseCustomElementUI> uiMap = new HashMap<>();

    /**
     * 注册 UI 模版
     * @param abstractMessageUI
     * @param <T>
     */
    public <T extends BaseCustomElementUI> void registerMessageUI(T abstractMessageUI) {
        Annotation annotation = abstractMessageUI.getClass().getAnnotation(CustomUIType.class);
        if (annotation == null) {
            throw new RuntimeException("register MessageUI with out Annotation~!");
        }
        CustomUIType customUIType = (CustomUIType) annotation;
        Class<?> cls = customUIType.contentCls();
        if (cls == null) {
            throw new RuntimeException("register MessageUI with out Message class");
        }
        uiMap.put(cls, abstractMessageUI);
        Log.i(TAG, "registerMessageUI() cls: " + cls + "abstractMessageUI: " + abstractMessageUI);
    }

    /**
     * 获取 UI 模版
     * @param cls
     * @return
     */
    public BaseCustomElementUI getMessageUI(Class<? extends BIMBaseElement> cls) {
        if (!uiMap.containsKey(cls)) {
            throw new RuntimeException("getMessageUI not exist cls: " + cls);
        }
        return uiMap.get(cls);
    }
}

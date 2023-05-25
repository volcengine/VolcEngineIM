package com.bytedance.im.ui.message.convert.manager;

import com.bytedance.im.core.model.inner.msg.BIMCustomElement;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.convert.base.model.BaseCustomElement;
import com.google.gson.Gson;

import org.json.JSONObject;

import java.util.HashMap;

public class BIMMessageManager {
    private static final String TAG = "VEMessageManager";

    private static class SingleHolder {
        private static final BIMMessageManager instance = new BIMMessageManager();
    }

    /**
     * 获取单例
     * @return
     */
    public static BIMMessageManager getInstance() {
        return SingleHolder.instance;
    }

    /**
     * 初始化
     */
    private void init() {

    }


    private HashMap<String, Class<? extends BaseCustomElement>> mapTC = new HashMap<>();
    private HashMap<Class<? extends BaseCustomElement>, String> mapCT = new HashMap<>();

    private BIMMessageManager() {

    }

    /**
     * 注册消息 content
     * @param type
     * @param cls
     */
    public void register(String type, Class<? extends BaseCustomElement> cls) {
        mapTC.put(type, cls);
        mapCT.put(cls, type);
    }

    public Class<? extends BaseCustomElement> getMessageCls(String type) throws Exception {
        Class<? extends BaseCustomElement> cls = mapTC.get(type);
        if (cls == null) {
            throw new RuntimeException("getMessageCls type:" + type + " cls is null");
        }
        return cls;
    }

    public String getMessageType(Class<? extends BaseCustomElement> cls) throws Exception {
        String type = mapCT.get(cls);
        if (cls == null) {
            throw new RuntimeException("getMessageType cls:" + type + " cls is null");
        }
        return type;
    }

    public <T extends BaseCustomElement> String encode(T content) {
        try {
            JSONObject object = content.encode();
            object.put("type", getMessageType(content.getClass()));
            return object.toString();
        } catch (Exception e) {
            BIMLog.i(TAG, "decode failed content: " + content + " e: " + e);
        }
        return null;
    }

    public BaseCustomElement decode(String json) {
        try {
            JSONObject o = new JSONObject(json);
            String type = o.getString("type");
            Class<? extends BaseCustomElement> cls = getMessageCls(type);
            BaseCustomElement element = cls.newInstance();
            element.setType(type);
            element.decode(json);
            return element;
        } catch (Exception e) {
            BIMLog.i(TAG, "encode failed json: " + json + " e: " + e);
        }
        return null;
    }
}

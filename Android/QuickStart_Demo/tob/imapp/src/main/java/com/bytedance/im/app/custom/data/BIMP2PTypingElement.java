package com.bytedance.im.app.custom.data;

import com.bytedance.im.core.model.inner.msg.BaseCustomElement;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class BIMP2PTypingElement extends BaseCustomElement {
    private Map<String,String> ext;
    private int messageType;

    public BIMP2PTypingElement() {
    }

    @Override
    public void decode(String data) {
        super.decode(data);
        try {
            JSONObject jsonObject = new JSONObject(data);
            messageType = jsonObject.getInt("message_type");
            JSONObject map = jsonObject.getJSONObject("ext");
            if (map != null) {
                ext = new HashMap<>();
                Iterator<String> iterator = map.keys();
                while (iterator.hasNext()) {
                    String key = iterator.next();
                    ext.put(key, map.getString(key));
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public JSONObject encode() {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("message_type", messageType);
            jsonObject.put("ext", ext);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    public Map<String, String> getExt() {
        return ext;
    }

    public void setExt(Map<String, String> ext) {
        this.ext = ext;
    }

    public int getMessageType() {
        return messageType;
    }

    public void setMessageType(int messageType) {
        this.messageType = messageType;
    }

    @Override
    public String toString() {
        return "BIMP2PTypingElement{" +
                "ext=" + ext +
                ", messageType=" + messageType +
                '}';
    }
}

package com.bytedance.im.ui.message.adapter.ui.custom;

import android.text.TextUtils;

import com.bytedance.im.core.model.inner.msg.BaseCustomElement;
import com.bytedance.im.ui.utils.BIMUtils;

import org.json.JSONException;
import org.json.JSONObject;

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
            String extJson = jsonObject.getString("ext");
            if (!TextUtils.isEmpty(extJson)) {
                ext = BIMUtils.stringToMap(extJson);
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
            if (ext != null) {
                jsonObject.put("ext", BIMUtils.mapToString(ext));
            }
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

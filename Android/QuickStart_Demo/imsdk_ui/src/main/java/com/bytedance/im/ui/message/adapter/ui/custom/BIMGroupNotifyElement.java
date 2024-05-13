package com.bytedance.im.ui.message.adapter.ui.custom;

import com.bytedance.im.core.model.inner.msg.BaseCustomElement;

import org.json.JSONException;
import org.json.JSONObject;

public class BIMGroupNotifyElement extends BaseCustomElement {
    private String text;

    @Override
    public void decode(String data) {
        super.decode(data);
        try {
            JSONObject jsonObject = new JSONObject(data);
            text = jsonObject.getString("text");
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public JSONObject encode() {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("text", text);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    public void setText(String text) {
        this.text = text;
    }

    @Override
    public String getMsgHint() {
        return "[系统消息]";
    }

    public String getText() {
        return text;
    }
}

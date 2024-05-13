package com.bytedance.im.ui.message.adapter.ui.custom;

import com.bytedance.im.core.model.inner.msg.BaseCustomElement;

import org.json.JSONException;
import org.json.JSONObject;

public class BIMShareElement extends BaseCustomElement {
    private String link;

    private String text;

    public BIMShareElement() {
        super();
    }

    @Override
    public void decode(String data) {
        try {
            JSONObject jsonObject = new JSONObject(data);
            link = jsonObject.getString("link");
            text = jsonObject.getString("text");
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public JSONObject encode() {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("link", link);
            jsonObject.put("text", text);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    @Override
    public String getMsgHint() {
        return "[自定义消息]";
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}

package com.bytedance.im.ui.message.convert.base.model;

import com.bytedance.im.core.model.inner.msg.BIMCustomElement;

import org.json.JSONObject;

public class BaseCustomElement extends BIMCustomElement {
    /**
     * @hidden
     */
    private String type;


    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public JSONObject encode() {
        return null;
    }

    public void decode(String data) {

    }

    public BaseCustomElement() {
    }
}

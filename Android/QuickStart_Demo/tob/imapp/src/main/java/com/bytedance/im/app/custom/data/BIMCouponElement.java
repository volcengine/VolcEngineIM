package com.bytedance.im.app.custom.data;

import com.bytedance.im.core.model.inner.msg.BaseCustomElement;

import org.json.JSONException;
import org.json.JSONObject;

public class BIMCouponElement extends BaseCustomElement {
    private String couponDetail;
    private int start;
    private int end;

    public BIMCouponElement() {
    }


    @Override
    public void decode(String data) {
        try {
            JSONObject jsonObject = new JSONObject(data);
            couponDetail = jsonObject.getString("detail");
            start = jsonObject.getInt("start");
            end = jsonObject.getInt("end");
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public JSONObject encode() {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("detail", couponDetail);
            jsonObject.put("start", start);
            jsonObject.put("end", end);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    @Override
    public String getMsgHint() {
        return "[自定义]";
    }

    public String getCouponDetail() {
        return couponDetail;
    }

    public void setCouponDetail(String couponDetail) {
        this.couponDetail = couponDetail;
    }

    public int getStart() {
        return start;
    }

    public int getEnd() {
        return end;
    }

    public void setRange(int s, int e) {
        start = s;
        end = e;
    }

    @Override
    public String toString() {
        return "BIMCouponElement{" +
                "couponDetail='" + couponDetail + '\'' +
                ", start=" + start +
                ", end=" + end +
                '}';
    }
}

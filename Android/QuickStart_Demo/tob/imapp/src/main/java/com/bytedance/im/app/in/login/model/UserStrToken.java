package com.bytedance.im.app.in.login.model;

public class UserStrToken {
    private long appId;
    private String uidStr;
    private String token;

    public UserStrToken(long appId, String uidStr, String token) {
        this.appId = appId;
        this.uidStr = uidStr;
        this.token = token;
    }

    public long getAppId() {
        return appId;
    }

    public void setAppId(long appId) {
        this.appId = appId;
    }

    public String getUidStr() {
        return uidStr;
    }

    public void setUidStr(String uidStr) {
        this.uidStr = uidStr;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}

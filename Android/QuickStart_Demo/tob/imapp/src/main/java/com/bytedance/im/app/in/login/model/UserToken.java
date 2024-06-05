package com.bytedance.im.app.in.login.model;

public class UserToken {
    private long appId;
    private long uid;
    private String token;

    public UserToken(long appID, long uid, String token) {
        this.uid = uid;
        this.token = token;
        this.appId = appID;
    }

    public long getUid() {
        return uid;
    }

    public void setUid(long uid) {
        this.uid = uid;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public long getAppId() {
        return appId;
    }

    public void setAppId(long appId) {
        this.appId = appId;
    }

    @Override
    public String toString() {
        return "UserToken{" +
                "appId=" + appId +
                ", uid=" + uid +
                ", token='" + token + '\'' +
                '}';
    }
}

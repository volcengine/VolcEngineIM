package com.bytedance.im.app.login.model;

public class UserToken {
    private long uid;
    private String token;
    private String name = "";

    public UserToken(long uid, String token) {
        this.uid = uid;
        this.token = token;
    }

    public UserToken(long uid, String name, String token) {
        this.uid = uid;
        this.name = name;
        this.token = token;
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

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "UserToken{" +
                "uid=" + uid +
                ", token='" + token + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}

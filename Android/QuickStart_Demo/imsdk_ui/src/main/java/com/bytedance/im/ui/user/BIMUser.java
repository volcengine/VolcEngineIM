package com.bytedance.im.ui.user;

public class BIMUser {
    public BIMUser(int headImg, String nickName, long uuid) {
        this.headImg = headImg;
        this.nickName = nickName;
        this.uuid = uuid;
    }

    private int headImg;
    private String nickName;
    private long uuid;

    public int getHeadImg() {
        return headImg;
    }

    public String getNickName() {
        return nickName;
    }

    public long getUuid() {
        return uuid;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }
}

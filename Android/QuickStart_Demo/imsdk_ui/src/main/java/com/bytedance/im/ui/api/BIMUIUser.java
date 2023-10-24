package com.bytedance.im.ui.api;

import com.bytedance.im.ui.R;

/**
 * @type keytype
 * @brief 用户信息。
 */
public class BIMUIUser {
    /**
     * @hidden
     */
    public BIMUIUser(int headImg, String url, String nickName, long userID) {
        if (headImg == -1) {
            this.headImg = R.drawable.icon_recommend_user_default;
        } else {
            this.headImg = headImg;
        }
        this.nickName = nickName;
        this.userID = userID;
        this.url = url;
    }

    /**
     * @hidden
     */
    public BIMUIUser(int headImg, String nickName, long userID) {
        this(headImg, "", nickName, userID);
    }

    /**
     * @hidden
     */
    public BIMUIUser(String url, String nickName, long userID) {
        this(-1, url, nickName, userID);
    }

    /**
     * @hidden
     */
    private int headImg;
    /**
     * @hidden
     */
    private String nickName;
    /**
     * @hidden
     */
    private long userID;
    /**
     * @hidden
     */
    private String url;

    /**
     * @return 用户头像
     * @type api
     * @brief 获取用户头像 resId
     */
    public int getHeadImg() {
        return headImg;
    }

    /**
     * @return 用户头像
     * @type api
     * @brief 获取用户头像 url
     */
    public String getHeadUrl() {
        return url;
    }

    /**
     * @return 用户昵称
     * @type api
     * @brief 获取用户头昵称
     */
    public String getNickName() {
        return nickName;
    }

    /**
     * @return 用户 id
     * @type api
     * @brief 获取用户 id
     */
    public long getUserID() {
        return userID;
    }

    /**
     * @hidden
     */
    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    /**
     * @hidden
     */
    public void setHeadImg(int headImg) {
        this.headImg = headImg;
    }

    /**
     * @hidden
     */
    public void setUserID(long userID) {
        this.userID = userID;
    }

    /**
     * @hidden
     */
    public void setUrl(String url) {
        this.url = url;
    }


}

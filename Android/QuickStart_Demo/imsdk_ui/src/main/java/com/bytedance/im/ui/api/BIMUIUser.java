package com.bytedance.im.ui.api;

/**
 * @type keytype
 * @brief 用户信息。
 */
public class BIMUIUser {
    /**
     * @hidden
     */
    private long uid;
    /**
     * @hidden
     */
    private String uidString;

    /**
     * @hidden
     */
    private String portraitUrl;

    /**
     * @hidden
     */
    private String nickName;   //用户资料
    /**
     * @hidden
     */
    private String alias;   //好友备注
    /**
     * @hidden
     */
    private String memberAlias; //群成员备注
    /**
     * @hidden
     */
    private String memberPortraitUrl;//群成员备注头像
    /**
     * @hidden
     */
    private boolean isBlock;
    /**
     * @hidden
     */
    private boolean isFriend;

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
    public long getUid() {
        return uid;
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
    public void setUid(long uid) {
        this.uid = uid;
    }

    /**
     * @hidden
     */
    public void setPortraitUrl(String portraitUrl) {
        this.portraitUrl = portraitUrl;
    }

    /**
     * @hidden
     */
    public String getMemberPortraitUrl() {
        return memberPortraitUrl;
    }
    /**
     * @hidden
     */
    public void setMemberPortraitUrl(String memberPortraitUrl) {
        this.memberPortraitUrl = memberPortraitUrl;
    }

    /**
     * @return 用户头像
     * @type api
     * @brief 获取用户头像 url
     */
    public String getPortraitUrl() {
        return portraitUrl;
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public boolean isBlock() {
        return isBlock;
    }

    public void setBlock(boolean block) {
        isBlock = block;
    }

    public boolean isFriend() {
        return isFriend;
    }

    public void setFriend(boolean friend) {
        isFriend = friend;
    }

    public String getMemberAlias() {
        return memberAlias;
    }

    public String getUidString() {
        return uidString;
    }

    public void setUidString(String uidString) {
        this.uidString = uidString;
    }

    public void setMemberAlias(String memberAlias) {
        this.memberAlias = memberAlias;
    }

    //避免业务层直接修改内存缓存
    public BIMUIUser clone() {
        BIMUIUser user = new BIMUIUser();
        user.setUid(this.getUid());
        user.setNickName(this.getNickName());
        user.setAlias(this.getAlias());
        user.setPortraitUrl(this.getPortraitUrl());
        user.setFriend(this.isFriend());
        user.setBlock(this.isBlock());
        user.setMemberAlias(this.getMemberAlias());
        user.setMemberPortraitUrl(this.getMemberPortraitUrl());
        user.setUidString(this.getUidString());
        return user;
    }
}

package com.bytedance.im.app.contact.blockList;

import com.bytedance.im.user.api.model.BIMBlackListFriendInfo;

public class VEContactBlackListData {
    private static char SPECIAL = '#';

    private BIMBlackListFriendInfo blackListFriendInfo;
    private char firstChar;
    private String sortKey;
    private String name;
    private long id;

    public static VEContactBlackListData create(BIMBlackListFriendInfo blackListFriendInfo) {
        String name = "用户" + blackListFriendInfo.getUid();
        String sortKey = "YH" + blackListFriendInfo.getUid();
        return new VEContactBlackListData(blackListFriendInfo.getUid(), name, sortKey, blackListFriendInfo);
    }

    public static int compare(VEContactBlackListData d1, VEContactBlackListData d2) {
        return Long.compare(d1.getId(), d2.getId());
    }

    public VEContactBlackListData(long id, String name, String sortKey, BIMBlackListFriendInfo bimBlackListFriendInfo) {
        this.id = id;
        this.name = name;
        this.sortKey = sortKey;
        this.blackListFriendInfo = bimBlackListFriendInfo;
        this.firstChar = (sortKey != null ? sortKey : ("" + SPECIAL)).charAt(0);
    }

    public char getFirstChar() {
        return firstChar;
    }

    public void setFirstChar(char firstChar) {
        this.firstChar = firstChar;
    }

    public String getSortKey() {
        return sortKey;
    }

    public void setSortKey(String sortKey) {
        this.sortKey = sortKey;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public BIMBlackListFriendInfo getBlackListFriendInfo() {
        return blackListFriendInfo;
    }
}

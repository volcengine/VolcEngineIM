package com.bytedance.im.app.contact.blockList;

import com.bytedance.im.imsdk.contact.user.api.model.BIMUserFullInfo;

import java.util.Locale;

public class VEContactBlackListData {
    private static char SPECIAL = '#';

    private BIMUserFullInfo userFullInfo;
    private char firstChar;
    private String sortKey;
    private String name;
    private long id;

    public static VEContactBlackListData create(BIMUserFullInfo blackListFriendInfo) {
        String name = "用户" + blackListFriendInfo.getUid();
        String sortKey = "YH" + blackListFriendInfo.getUid();
        return new VEContactBlackListData(blackListFriendInfo.getUid(), name, sortKey, blackListFriendInfo);
    }

    public static int compare(VEContactBlackListData o1, VEContactBlackListData o2) {
        if (o1.getFirstChar() == o2.getFirstChar()) {
            return o1.getSortKey().toUpperCase(Locale.ROOT).compareTo(o2.getSortKey().toUpperCase(Locale.ROOT));
        } else if (o1.getFirstChar() == SPECIAL) {
            return 1;
        } else if (o2.getFirstChar() == SPECIAL) {
            return -1;
        } else {
            return o1.getSortKey().toUpperCase(Locale.ROOT).compareTo(o2.getSortKey().toUpperCase(Locale.ROOT));
        }
    }

    public VEContactBlackListData(long id, String name, String sortKey, BIMUserFullInfo bimBlackListFriendInfo) {
        this.id = id;
        this.name = name;
        this.sortKey = sortKey;
        this.userFullInfo = bimBlackListFriendInfo;
        this.firstChar = (sortKey != null ? sortKey : ("" + SPECIAL)).charAt(0);
    }

    public char getFirstChar() {
        char c = this.sortKey.charAt(0);
        if (Character.isLetter(c)) {
            return Character.toUpperCase(c);
        } else {
            return SPECIAL;
        }
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

    public BIMUserFullInfo getUserFullInfo() {
        return userFullInfo;
    }
}

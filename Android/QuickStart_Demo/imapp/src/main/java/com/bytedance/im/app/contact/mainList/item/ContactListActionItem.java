package com.bytedance.im.app.contact.mainList.item;

import com.bytedance.im.app.R;

public class ContactListActionItem {
    public static long ITEM_INVITE_LIST = -1L;
    public static long ITEM_BLOCK_LIST = -2L;

    public static ContactListActionItem BLOCK_LIST = new ContactListActionItem("黑名单", R.drawable.icon_recommend_user_default, 0, ITEM_BLOCK_LIST);
    public static ContactListActionItem INVITE_LIST = new ContactListActionItem("好友申请", R.drawable.icon_recommend_user_default, 0, ITEM_INVITE_LIST);

    private long id;
    private String name;
    private int unreadCount;
    private int iconResourceId;

    public ContactListActionItem(String name, int iconResourceId, int unreadCount, long id) {
        this.id = id;
        this.name = name;
        this.unreadCount = unreadCount;
        this.iconResourceId = iconResourceId;
    }

    public String getName() {
        return name;
    }

    public int getIconResourceId() {
        return iconResourceId;
    }

    public int getUnreadCount() {
        return unreadCount;
    }

    public void setUnreadCount(int newCount) {
        this.unreadCount = newCount;
    }
}

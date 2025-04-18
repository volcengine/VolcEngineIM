package com.bytedance.im.app.contact.mainList;

import static com.bytedance.im.app.contact.mainList.item.ContactListActionItem.BLOCK_LIST;
import static com.bytedance.im.app.contact.mainList.item.ContactListActionItem.INVITE_LIST;
import static com.bytedance.im.app.contact.mainList.item.ContactListActionItem.ITEM_BLOCK_LIST;
import static com.bytedance.im.app.contact.mainList.item.ContactListActionItem.ITEM_INVITE_LIST;
import static com.bytedance.im.app.contact.mainList.item.ContactListActionItem.ITEM_ROBOT_LIST;
import static com.bytedance.im.app.contact.mainList.item.ContactListActionItem.ROBOT_LIST;

import android.text.TextUtils;

import com.bytedance.im.app.contact.SimplePinyinHelper;
import com.bytedance.im.app.contact.mainList.item.ContactListActionItem;


import com.bytedance.im.app.contact.utils.ContactNameUtils;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.Locale;

public class ContactListDataInfo<T> {
    public static final char SPECIAL_NAME = '#';

    private T data;
    private long id;
    private int type;
    private String name;
    private String sortKey;

    public static ContactListDataInfo<BIMUserFullInfo> create(BIMUserFullInfo fullInfo) {
        String name = ContactNameUtils.getShowName(fullInfo);
        String sortKey = "";
        if (SimplePinyinHelper.ifValid(name)) {
            sortKey = SimplePinyinHelper.getFirstPinyinChar(name);
        } else {
            sortKey = name;
        }
        return new ContactListDataInfo<BIMUserFullInfo>(fullInfo, ContactListItemType.TYPE_CONTACT, sortKey, fullInfo.getUid(), name);
    }

    public static ContactListDataInfo<ContactListActionItem> create(int type) {
        if (type == ContactListItemType.TYPE_BLACK_LIST) {
            return new ContactListDataInfo<>(BLOCK_LIST, ContactListItemType.TYPE_BLACK_LIST, "", ITEM_BLOCK_LIST, "");
        } else if (type == ContactListItemType.TYPE_INVITE_LIST) {
            return new ContactListDataInfo<>(INVITE_LIST, ContactListItemType.TYPE_INVITE_LIST, "", ITEM_INVITE_LIST, "");
        } else if (type ==ContactListItemType.TYPE_ROBOT_LIST) {
            return new ContactListDataInfo<>(ROBOT_LIST, ContactListItemType.TYPE_ROBOT_LIST, "", ITEM_ROBOT_LIST, "");
        }
        return null;
    }

    public static int compare(ContactListDataInfo<?> o1, ContactListDataInfo<?> o2) {
        if (o1.getFirstChar() == o2.getFirstChar()) {
            return o1.getSortKey().toUpperCase(Locale.ROOT).compareTo(o2.getSortKey().toUpperCase(Locale.ROOT));
        } else if (o1.getFirstChar() == SPECIAL_NAME) {
            return 1;
        } else if (o2.getFirstChar() == SPECIAL_NAME) {
            return -1;
        } else {
            return o1.getSortKey().toUpperCase(Locale.ROOT).compareTo(o2.getSortKey().toUpperCase(Locale.ROOT));
        }
    }

    public ContactListDataInfo(T realData, int type, String sortKey, long id, String name) {
        this.id = id;
        this.type = type;
        this.name = name;
        this.data = realData;
        this.sortKey = sortKey;
    }

    public T getData() {
        return this.data;
    }

    public int getType() {
        return this.type;
    }

    public String getSortKey() {
        if (TextUtils.isEmpty(this.sortKey)) {
            return "";
        }
        return this.sortKey;
    }

    public char getFirstChar() {
        char c = this.sortKey.charAt(0);
        if (Character.isLetter(c)) {
            return Character.toUpperCase(c);
        } else {
            return SPECIAL_NAME;
        }
    }

    public String getName() {
        return name;
    }

    public long getId() { return this.id; }
}
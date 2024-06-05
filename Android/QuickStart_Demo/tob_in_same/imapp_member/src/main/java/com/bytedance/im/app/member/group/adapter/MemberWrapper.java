package com.bytedance.im.app.member.group.adapter;

import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.api.BIMUIUser;

public class MemberWrapper {
    public static final int TYPE_NORMAL = 0;
    public static final int TYPE_ADD = 1;
    public static final int TYPE_DELETE = 2;
    private BIMMember member;
    private BIMUIUser user;
    private int type;
    public boolean isSelect;
    private int order;
    private boolean isOwner;
    private boolean isShowSilent;
    private boolean isShowOnline;
    private boolean isShowTag = true;
    public MemberWrapper(BIMMember member, BIMUIUser user,int type) {
        order = generateOrder(member, type);
        this.member = member;
        this.user = user;
        this.type = type;
    }

    public void setUser(BIMUIUser user) {
        this.user = user;
    }

    public void setOwner(boolean owner) {
        isOwner = owner;
    }

    public boolean isOwner() {
        return isOwner;
    }

    public BIMMember getMember() {
        return member;
    }

    public int getType() {
        return type;
    }

    public int getOrder() {
        return order;
    }

    public boolean isShowSilent() {
        return isShowSilent;
    }

    public void setShowSilent(boolean showSilent) {
        this.isShowSilent = showSilent;
    }

    public boolean isShowOnline() {
        return isShowOnline;
    }

    public void setShowOnline(boolean showOnline) {
        isShowOnline = showOnline;
    }

    private int generateOrder(BIMMember member, int type) {
        int order = 0;
        if (type == TYPE_DELETE) {
            order = 1000;
        } else if (type == TYPE_ADD) {
            order = 900;
        } else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_NORMAL) {
            order = 800;
        } else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
            order = 700;
        } else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
            order = 600;
        }
        return order;
    }

    public boolean isShowTag() {
        return isShowTag;
    }

    public void setShowTag(boolean showTag) {
        isShowTag = showTag;
    }

    public BIMUIUser getUser() {
        return user;
    }
}

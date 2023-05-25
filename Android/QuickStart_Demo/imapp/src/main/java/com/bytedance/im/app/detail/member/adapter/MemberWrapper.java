package com.bytedance.im.app.detail.member.adapter;

import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.proto.GroupRole;

public class MemberWrapper {
    public static final int TYPE_NORMAL = 0;
    public static final int TYPE_ADD = 1;
    public static final int TYPE_DELETE = 2;
    private BIMMember member;
    private int type;
    public boolean isSelect;
    private int order;
    private boolean isOwner;
    private boolean forceSilentGone;
    public MemberWrapper(BIMMember member, int type) {
        order = generateOrder(member, type);
        this.member = member;
        this.type = type;
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

    public boolean isForceSilentGone() {
        return forceSilentGone;
    }

    public void setForceSilentGone(boolean forceSilentGone) {
        this.forceSilentGone = forceSilentGone;
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
}

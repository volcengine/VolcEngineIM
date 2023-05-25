package com.bytedance.im.ui.member;

import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.proto.GroupRole;

public class BIMMemberWrapper {
    public static final int TYPE_NORMAL = 0;
    private BIMMember member;
    private int type;
    public boolean isSelect;
    private int order;
    private boolean isOwner;
    public BIMMemberWrapper(BIMMember member, int type) {
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

    private int generateOrder(BIMMember member, int type) {
        int order = 0;
        if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_NORMAL) {
            order = 800;
        } else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
            order = 700;
        } else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
            order = 600;
        }
        return order;
    }
}

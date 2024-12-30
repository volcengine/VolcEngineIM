package com.bytedance.im.app.member.group.adapter;

import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.model.Member;

import java.util.Collections;
import java.util.List;

public class MemberUtils {
    /**
     * 群成员排序
     *
     * @param data
     */
    public static void sortWrap(List<MemberWrapper> data) {
        Collections.sort(data, (o1, o2) -> {
            int tr = o1.getOrder() - o2.getOrder();
            if (tr == 0) {
                return (int) (o1.getMember().getUserID() - (int) o2.getMember().getUserID());
            } else {
                return tr;
            }
        });
    }

    public static void sortMember(List<BIMMember> sortList) {
        Collections.sort(sortList, (o1, o2) -> {
            int r1 = genOrder(o1);
            int r2 = genOrder(o2);
            return r2 - r1;
        });
    }

    private static int genOrder(BIMMember member) {
        BIMMemberRole role = member.getRole();
        if (role == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
            return 1000;
        } else if (role == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
            return 900;
        } else if (role == BIMMemberRole.BIM_MEMBER_ROLE_NORMAL) {
            return 800;
        }
        return 0;
    }
}

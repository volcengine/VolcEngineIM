package com.bytedance.im.app.member.group.adapter;

import java.util.Collections;
import java.util.List;

public class MemberUtils {
    /**
     * 群成员排序
     *
     * @param data
     */
    public static void sort(List<MemberWrapper> data) {
        Collections.sort(data, (o1, o2) -> {
            int tr = o1.getOrder() - o2.getOrder();
            if (tr == 0) {
                return (int) (o1.getMember().getUserID() - (int)o2.getMember().getUserID());
            } else {
                return tr;
            }
        });
    }
}

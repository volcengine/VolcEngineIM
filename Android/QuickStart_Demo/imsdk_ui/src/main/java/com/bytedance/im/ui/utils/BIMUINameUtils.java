package com.bytedance.im.ui.utils;

import android.text.TextUtils;

import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.List;

public class BIMUINameUtils {
    //公开场景：用户资料>兜底uid
    public static String getShowNickName(BIMUIUser user) {
        if (user == null) {
            return "default";
        }
        String name = "用户" + user.getUid();         //用户ID
        if (!TextUtils.isEmpty(user.getNickName())) { //用户资料名
            name = user.getNickName();
        }
        return name;
    }

    //好友场景 好友备注>用户资料>兜底uid
    public static String getShowName(BIMUIUser user) {
        if (user == null) {
            return "default";
        }
        String name = "用户" + user.getUid();         //用户ID
        if (user != null) {
            if (!TextUtils.isEmpty(user.getNickName())) { //用户资料名
                name = user.getNickName();
            }
            if (!TextUtils.isEmpty(user.getAlias())) {  //好友备注名
                name = user.getAlias();
            }
        }
        return name;
    }

    //群内名称  好友备注>群内备注>用户资料>兜底uid
    public static String getShowNameInGroup(BIMMember member, BIMUIUser user) {
        if (user == null) {
            if (member != null && !TextUtils.isEmpty(member.getAlias())) {
                return member.getAlias();
            }
            return "用户" + member.getUserID();
        } else {
            String name = "用户" + user.getUid();         //用户ID
            if (!TextUtils.isEmpty(user.getNickName())) { //用户资料名
                name = user.getNickName();
            }
            if (!TextUtils.isEmpty(user.getMemberAlias())) {          //直播群内名称
                name = user.getMemberAlias();
            }
            if (member != null && !TextUtils.isEmpty(member.getAlias())) {
                name = member.getAlias();
            }
            if (!TextUtils.isEmpty(user.getAlias())) {  //好友备注名
                name = user.getAlias();
            }
            return name;
        }
    }

    //头像展示 群内备注>用户资料
    public static String getPortraitUrl(BIMMember member, BIMUIUser user) {
        if (user == null) {
            return "default";
        }
        String url = user.getPortraitUrl();         //用户资料
        if (!TextUtils.isEmpty(member.getAvatarUrl())) {
            url = member.getAvatarUrl();                //群内备注
        }
        return url;
    }

    //拼接用户资料名称
    public static String buildNickNameList(List<BIMUIUser> infoList) {
        if (infoList == null || infoList.isEmpty()) return "";
        StringBuilder builder = new StringBuilder();
        for (BIMUIUser info : infoList) {
            builder.append(getShowNickName(info));
            builder.append(",");
        }
        return builder.substring(0, builder.length() - 1);
    }
}

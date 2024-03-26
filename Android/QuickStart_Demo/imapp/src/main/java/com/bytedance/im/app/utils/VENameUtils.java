package com.bytedance.im.app.utils;

import android.text.TextUtils;
import android.widget.ImageView;

import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.List;

public class VENameUtils {
    //公开场景：用户资料>兜底uid
    public static String getShowNickName(BIMUserFullInfo fullInfo) {
        String name = "用户" + fullInfo.getUid();         //用户ID
        if (!TextUtils.isEmpty(fullInfo.getNickName())) { //用户资料名
            name = fullInfo.getNickName();
        }
        return name;
    }

    //好友场景 好友备注>用户资料>兜底uid
    public static String getShowName(BIMUserFullInfo fullInfo) {
        String name = "用户" + fullInfo.getUid();         //用户ID
        if (fullInfo != null) {
            if (!TextUtils.isEmpty(fullInfo.getNickName())) { //用户资料名
                name = fullInfo.getNickName();
            }
            if (!TextUtils.isEmpty(fullInfo.getAlias())) {  //好友备注名
                name = fullInfo.getAlias();
            }
        }
        return name;
    }

    //群内名称  好友备注>群内备注>用户资料>兜底uid
    public static String getShowNameInGroup(MemberWrapper memberWrapper) {
        BIMMember member = memberWrapper.getMember();
        BIMUserFullInfo fullInfo = memberWrapper.getFullInfo();
        String name = "用户" + fullInfo.getUid();         //用户ID
        if (!TextUtils.isEmpty(fullInfo.getNickName())) { //用户资料名
            name = fullInfo.getNickName();
        }
        if (!TextUtils.isEmpty(member.getAlias())) {          //群内名称
            name = member.getAlias();
        }
        if (!TextUtils.isEmpty(fullInfo.getAlias())) {  //好友备注名
            name = fullInfo.getAlias();
        }
        return name;
    }
    //头像展示 群内备注>用户资料
    public static String getPortraitUrl(MemberWrapper memberWrapper) {
        BIMMember member = memberWrapper.getMember();
        BIMUserFullInfo fullInfo = memberWrapper.getFullInfo();
        String url = fullInfo.getPortraitUrl();         //用户资料
        if (!TextUtils.isEmpty(member.getAvatarUrl())) {
            url = member.getAvatarUrl();                //群内备注
        }
        return url;
    }
    //拼接用户资料名称
    public static String buildNickNameList(List<BIMUserFullInfo> infoList) {
        if (infoList == null || infoList.isEmpty()) return "";
        StringBuilder builder = new StringBuilder();
        for (BIMUserFullInfo info : infoList) {
            builder.append(getShowNickName(info));
            builder.append(",");
        }
        return builder.substring(0, builder.length() - 1);
    }
}

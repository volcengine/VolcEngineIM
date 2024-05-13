package com.bytedance.im.app.contact.utils;

import android.text.TextUtils;

import com.bytedance.im.imsdk.contact.user.api.model.BIMUserFullInfo;

public class ContactNameUtils {

    public static String getShowName(BIMUserFullInfo userFullInfo) {
        String alias = userFullInfo.getAlias();
        String nickName = userFullInfo.getNickName();
        if (!TextUtils.isEmpty(alias)) {
            return alias;
        }
        if (!TextUtils.isEmpty(nickName)) {
            return nickName;
        }
        return "用户" + userFullInfo.getUid();
    }
}

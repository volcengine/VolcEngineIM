package com.bytedance.im.app.contact.robotList;

import android.text.TextUtils;

import com.bytedance.im.user.api.model.BIMUserFullInfo;
import com.bytedance.im.user.api.model.BIMUserProfile;


public class RobotDataWrapper {
    private BIMUserFullInfo rawData;
    private boolean selected = false;

    public RobotDataWrapper(BIMUserFullInfo rawData) {
        this.rawData = rawData;
    }

    public BIMUserFullInfo getRawData() {
        return rawData;
    }

    public String getName() {
        String nickName = rawData.getNickName();
        if (TextUtils.isEmpty(nickName)) {
            nickName = "用户" + rawData.getUid();
        }
        return nickName;
    }

    public String getAvatarUrl() {
        return rawData.getPortraitUrl();
    }

    public boolean getIsSelected() {
        return selected;
    }

    public void setIsSelected(boolean selected) {
        this.selected = selected;
    }

    public boolean isSame(RobotDataWrapper other) {
        if (other == null) {
            return false;
        }
        return other.rawData.getUid() == rawData.getUid();
    }
}
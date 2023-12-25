package com.bytedance.im.app.contact;

import android.text.TextUtils;
import android.util.Log;
import android.util.LruCache;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.user.BIMUserProvider;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.BIMFriendListener;
import com.bytedance.im.user.api.model.BIMBlackListFriendInfo;
import com.bytedance.im.user.api.model.BIMFriendApplyInfo;
import com.bytedance.im.user.api.model.BIMFriendInfo;
import com.bytedance.im.user.api.model.BIMUserFullInfo;
import com.bytedance.im.user.api.model.BIMUserProfile;


class DataWrapper {
    private long uid;
    private boolean isValid = false;
    private BIMFriendInfo friendInfo;

    public DataWrapper(BIMFriendInfo friendInfo, long uid) {
        this.uid = uid;
        this.friendInfo = friendInfo;
        isValid = friendInfo != null;
    }

    public boolean isValid() {
        return isValid;
    }

    public BIMFriendInfo getFriendInfo() {
        return friendInfo;
    }

    public void setFriendInfo(BIMFriendInfo friendInfo) {
        this.friendInfo = friendInfo;
        isValid = friendInfo != null;
    }

    public void resetFriendInfo() {
        setFriendInfo(null);
    }
}
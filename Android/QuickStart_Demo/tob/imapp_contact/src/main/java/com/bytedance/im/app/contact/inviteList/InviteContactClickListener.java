package com.bytedance.im.app.contact.inviteList;

import com.bytedance.im.imsdk.contact.user.api.model.BIMFriendApplyInfo;

public interface InviteContactClickListener {
    void onAgree(BIMFriendApplyInfo dataWrapper);
    void onReject(BIMFriendApplyInfo dataWrapper);
    void onPortraitClick(BIMFriendApplyInfo friendApplyInfo);
}

package com.bytedance.im.app.contact.inviteList;

import com.bytedance.im.user.api.model.BIMFriendApplyInfo;

public interface InviteContactClickListener {
    void onAgree(BIMFriendApplyInfo dataWrapper);
    void onReject(BIMFriendApplyInfo dataWrapper);
}

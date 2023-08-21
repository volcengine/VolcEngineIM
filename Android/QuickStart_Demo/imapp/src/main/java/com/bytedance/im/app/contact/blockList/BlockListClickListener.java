package com.bytedance.im.app.contact.blockList;

import com.bytedance.im.user.api.model.BIMFriendApplyInfo;

public interface BlockListClickListener {
    void onClick(BIMFriendApplyInfo dataWrapper);
    void onLongClick(BIMFriendApplyInfo dataWrapper);
}

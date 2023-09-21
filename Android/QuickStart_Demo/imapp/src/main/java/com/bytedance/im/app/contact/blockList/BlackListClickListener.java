package com.bytedance.im.app.contact.blockList;

import com.bytedance.im.user.api.model.BIMBlackListFriendInfo;

public interface BlackListClickListener {
    void onClick(VEContactBlackListData data);
    void onLongClick(VEContactBlackListData data);
}

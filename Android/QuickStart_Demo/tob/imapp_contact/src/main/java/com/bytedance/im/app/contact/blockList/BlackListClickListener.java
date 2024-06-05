package com.bytedance.im.app.contact.blockList;

public interface BlackListClickListener {
    void onClick(VEContactBlackListData data);
    void onLongClick(VEContactBlackListData data);
    void onPortraitClick(VEContactBlackListData data);
}

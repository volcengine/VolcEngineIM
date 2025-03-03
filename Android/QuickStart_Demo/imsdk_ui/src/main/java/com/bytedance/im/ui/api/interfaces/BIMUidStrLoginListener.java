package com.bytedance.im.ui.api.interfaces;

public interface BIMUidStrLoginListener {
    void onProtoAgree(String uidStr, String token);
    void doInit();

    void doLogin(String uidStr, String token);

    void onDebugClick();
}

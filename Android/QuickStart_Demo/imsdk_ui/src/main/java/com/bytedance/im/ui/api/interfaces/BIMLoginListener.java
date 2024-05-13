package com.bytedance.im.ui.api.interfaces;

public interface BIMLoginListener {
    void onProtoAgree(boolean usCache, long uid, String token);
    void doLogin(long uid, String token);
    void onDebugClick();
}

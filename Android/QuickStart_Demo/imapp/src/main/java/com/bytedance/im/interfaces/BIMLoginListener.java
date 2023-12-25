package com.bytedance.im.interfaces;

public interface BIMLoginListener {
    void onProtoAgree();
    void doLogin(long uid, String token);
    void onDebugClick();
}
